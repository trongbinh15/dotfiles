import { readdirSync } from "node:fs";

import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

// `.env.schema` is the non-secret Varlock contract. Every other dotenv file is
// protected, including `.env`, `.env.local`, and mode-specific variants.
const DOTENV_REFERENCE = /(?:^|[\s"'`=:/\\])(\.env(?:[A-Za-z0-9_.-]*)?)/gi;
const CLIPBOARD_COMMAND = /\b(?:pbcopy|xclip|xsel|wl-copy|clip(?:\.exe)?)\b/i;
const REMOVE_DOTENV_COMMAND = /^\s*rm(?:\s+-f)?\s+\.env(?:[A-Za-z0-9_.-]*)(?:\s+\.env(?:[A-Za-z0-9_.-]*))*\s*$/;

function stringifyToolInput(input: unknown): string | undefined {
	try {
		return typeof input === "string" ? input : (JSON.stringify(input) ?? "");
	} catch {
		return undefined;
	}
}

// For writes, protect the target path rather than safe replacement content.
const CONTENT_WRITE_TOOLS = new Set(["edit", "write"]);
// `glob` returns paths, not file contents, so dotenv discovery must remain available.
const PATH_DISCOVERY_TOOLS = new Set(["glob"]);

function isRemoveDotenvCommand(toolName: string, input: unknown): boolean {
	if (toolName !== "bash") return false;
	if (typeof input === "string") return REMOVE_DOTENV_COMMAND.test(input);
	if (typeof input !== "object" || input === null || Array.isArray(input)) return false;

	const command = (input as { command?: unknown }).command;
	return typeof command === "string" && REMOVE_DOTENV_COMMAND.test(command);
}


function writeTargetPath(input: unknown): string | undefined {
	if (typeof input !== "object" || input === null || Array.isArray(input)) return undefined;

	const path = (input as { path?: unknown }).path;
	return typeof path === "string" ? path : undefined;
}


function referencesProtectedDotenv(input: unknown): boolean {
	const text = stringifyToolInput(input);
	// Malformed/unserializable tool input is not safe to inspect. Fail closed.
	if (text === undefined) return true;

	for (const match of text.matchAll(DOTENV_REFERENCE)) {
		if (match[1].toLowerCase() !== ".env.schema") return true;
	}
	return false;
}

function hasProtectedDotenvFile(directory: string): boolean {
	try {
		return readdirSync(directory, { withFileTypes: true }).some(
			entry => (entry.isFile() || entry.isSymbolicLink()) && referencesProtectedDotenv(entry.name),
		);
	} catch {
		// An unreadable directory must not disable protection.
		return true;
	}
}


const BLOCKED_REASON =
	"Blocked by global OMP policy: dotenv files may only be resolved through Varlock; use varlock run/load instead of reading the file.";
const CLIPBOARD_REASON =
	"Blocked by global OMP policy: clipboard writes involving protected dotenv references are not allowed.";


/**
 * OMP model-tool policy for Varlock-managed dotenv files.
 *
 * This is a tool-call boundary: it blocks model-facing reads and writes
 * targeting protected dotenv files and arbitrary eval, while allowing path-only
 * glob discovery and dotenv filenames in content written to unrelated files.
 */
export default function noDotenvPolicy(pi: ExtensionAPI): void {
	pi.on("tool_call", async (event, ctx) => {
		if (isRemoveDotenvCommand(event.toolName, event.input)) return;
		// eval can import fs or spawn a shell without exposing a path in the
		// normalized tool arguments, so strict dotenv protection disables it.
		if (event.toolName === "eval") {
			return {
				block: true,
				reason: `${BLOCKED_REASON} The eval tool is disabled because it can bypass path checks.`,
			};
		}
		const inputText = stringifyToolInput(event.input);
		if (
			inputText !== undefined &&
			CLIPBOARD_COMMAND.test(inputText) &&
			referencesProtectedDotenv(event.input)
		) {
			return { block: true, reason: CLIPBOARD_REASON };
		}

		if (inputText === undefined) {
			return { block: true, reason: BLOCKED_REASON };
		}
		if (PATH_DISCOVERY_TOOLS.has(event.toolName)) return;

		const protectedInput = CONTENT_WRITE_TOOLS.has(event.toolName)
			? (writeTargetPath(event.input) ?? event.input)
			: event.input;
		if (referencesProtectedDotenv(protectedInput) && hasProtectedDotenvFile(ctx.cwd)) {
			return { block: true, reason: BLOCKED_REASON };
		}
	});
}
