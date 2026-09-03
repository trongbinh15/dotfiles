import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

// `.env.schema` is the non-secret Varlock contract. Every other dotenv file is
// protected, including `.env`, `.env.local`, and mode-specific variants.
const DOTENV_REFERENCE = /(?:^|[\s"'`=:/\\])(\.env(?:[A-Za-z0-9_.-]*)?)/gi;
const CLIPBOARD_COMMAND = /\b(?:pbcopy|xclip|xsel|wl-copy|clip(?:\.exe)?)\b/i;

function stringifyToolInput(input: unknown): string | undefined {
	try {
		return typeof input === "string" ? input : (JSON.stringify(input) ?? "");
	} catch {
		return undefined;
	}
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

const BLOCKED_REASON =
	"Blocked by global OMP policy: dotenv files may only be resolved through Varlock; use varlock run/load instead of reading the file.";
const CLIPBOARD_REASON =
	"Blocked by global OMP policy: clipboard writes are disabled because they can expose Varlock-managed secrets.";


/**
 * OMP model-tool policy for Varlock-managed dotenv files.
 *
 * This is a tool-call boundary, not an OS sandbox: it blocks model-facing
 * reads and arbitrary eval, while the OMP process itself still has its normal
 * startup dotenv behavior.
 */
export default function noDotenvPolicy(pi: ExtensionAPI): void {
	pi.on("tool_call", async event => {
		// eval can import fs or spawn a shell without exposing a path in the
		// normalized tool arguments, so strict dotenv protection disables it.
		if (event.toolName === "eval") {
			return {
				block: true,
				reason: `${BLOCKED_REASON} The eval tool is disabled because it can bypass path checks.`,
			};
		}
		const inputText = stringifyToolInput(event.input);
		if (inputText !== undefined && CLIPBOARD_COMMAND.test(inputText)) {
			return { block: true, reason: CLIPBOARD_REASON };
		}

		if (referencesProtectedDotenv(event.input)) {
			return { block: true, reason: BLOCKED_REASON };
		}
	});
}
