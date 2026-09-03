# Personal Dotfiles

A macOS-oriented development setup for Zsh, Neovim (LazyVim), Herdr, and Television. The README documents the portable configuration tracked in this repository; machine-local agent metadata is intentionally not part of the setup.

## Structure

```
├── .zshrc                         # Zsh, aliases, project helpers, Jira/Azure workflows
├── herdr/
│   ├── config.toml                # Herdr UI, keys, theme, sidebar rows
│   └── spreader/
│       └── hydra-workplaces.yaml  # Herdr workspace layout
├── nvim/
│   ├── init.lua                   # LazyVim bootstrap
│   ├── lazyvim.json               # LazyVim extras
│   └── lua/
│       ├── config/                # Options, keymaps, lazy.nvim setup
│       └── plugins/               # Local plugin specifications
├── omp/
│   └── no-dotenv-policy.ts        # Custom Oh My Pi Varlock policy extension
├── television/
│   ├── config.toml                # Television UI, keys, and shell integration
│   ├── cable/                     # Jira, Azure DevOps, and branch-task channels
│   └── jira-icons.jq              # Jira status and issue-type formatting helpers
└── README.md
```

Ignored or machine-local state is not part of the install: `nvim/lazy-lock.json`, `nvim/spell/`, `herdr/plugins/`, and `.serena/` are excluded by the repository ignore rules. The `vim-herdr-navigation` plugin is installed into the ignored `herdr/plugins/` directory during setup.

## Requirements

### Base tools

- macOS
- [Homebrew](https://brew.sh/)
- Zsh and [Oh My Zsh](https://ohmyz.sh/)
- [Git](https://git-scm.com/)
- [Neovim](https://neovim.io/) with LazyVim; Neovim 0.10+ is recommended for reliable Ctrl-H/Backspace handling inside Herdr panes
- [Herdr](https://herdr.dev/) 0.7.0 or newer
- [Television](https://github.com/alexpasmantier/television)
- [Node.js](https://nodejs.org/) through [fnm](https://github.com/Schniz/fnm)

### Feature-specific tools

- `jq` for Vim-aware Herdr navigation and Television formatting
- `fzf` for interactive branch/status selection in shell and Television actions
- `acli` for Jira work items and comments
- `az` (Azure CLI) for Azure DevOps pull requests and builds
- `lazygit` for the Herdr popup
- macOS clipboard support for copy/paste actions
- `bun`, `npm`, `pnpm`, or `yarn` for the package-manager helpers
- `zoxide`, `yt-dlp`, and `transmission-cli` for the corresponding shell helpers

## Installation

Several paths in the configuration intentionally assume the repository is at `~/dotfiles`: the `mux` helper, Neovim's Herdr navigation integration, and Television cable commands refer to that location.

### 1. Clone the repository

```bash
git clone https://github.com/your-username/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

### 2. Install base dependencies

```bash
brew install neovim starship fnm jq fzf lazygit zoxide yt-dlp transmission-cli

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Oh My Zsh plugin
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# The current .zshrc sources this checkout directly.
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$HOME/zsh-syntax-highlighting"
```

Install Television, Herdr, `acli`, and Azure CLI using their upstream installation instructions if they are not already available. `herdr` can be installed with:

```bash
curl -fsSL https://herdr.dev/install.sh | sh
```

### 3. Link the configurations

```bash
mkdir -p "$HOME/.config" "$HOME/.config/herdr" "$HOME/.config/television"

ln -sfn "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/herdr/config.toml" "$HOME/.config/herdr/config.toml"
ln -sf "$HOME/dotfiles/television/config.toml" "$HOME/.config/television/config.toml"
ln -sfn "$HOME/dotfiles/television/cable" "$HOME/.config/television/cable"
```

If the absolute `/Users/nguytb15/...` paths near the end of `.zshrc` do not match the machine, replace them with `$HOME`-based paths before starting a new shell. The same applies to any hard-coded personal paths added to local tooling.

### 4. Install Herdr plugins

```bash
mkdir -p "$HOME/dotfiles/herdr/plugins"

# Ctrl-H/J/K/L across Neovim splits and Herdr panes
git clone https://github.com/paulbkim-dev/vim-herdr-navigation \
  "$HOME/dotfiles/herdr/plugins/vim-herdr-navigation"
herdr plugin link "$HOME/dotfiles/herdr/plugins/vim-herdr-navigation"

# Hint-copy URLs, paths, SHAs, UUIDs, and IP addresses
herdr plugin install rmarganti/herdr-pluck

# Apply project layouts
herdr plugin install yuk1ty/herdr-spreader -y
```

`jq` is required for Vim/Neovim process detection. Without it, Ctrl-H/J/K/L still moves Herdr panes but cannot forward keys into Vim. Restart Herdr or reload its configuration with `Ctrl-g`, then `Shift-r`.

## Zsh configuration

`.zshrc` loads Oh My Zsh with the `git`, `vscode`, and `zsh-autosuggestions` plugins, initializes Starship and fnm, and adds Android SDK, Bun, pnpm, zoxide, Maestro, and Headroom environment setup. It also sources the optional Powerlevel10k instant-prompt/config hooks when present.

### Package-manager workflow

The helpers inspect the lockfile in the current directory and select Bun, Yarn, npm, or pnpm. With no lockfile they fall back to pnpm.

| Command | Action |
| --- | --- |
| `pit` | Install dependencies |
| `pt` | Run tests |
| `pd` | Run the development command |
| `pb` | Run the build command |

### Aliases and utilities

| Command | Behavior |
| --- | --- |
| `ps` | `pnpm run start` |
| `pra` / `pri` | `pnpm run android` / `pnpm run ios` |
| `yta` | Extract audio from a URL with `yt-dlp` as an MP3 in the current directory |
| `tor [flags] [url]` | Run `transmission-cli` into `~/Downloads`; use the macOS clipboard when no URL is supplied |
| `zshconfig` | Open `.zshrc` in Neovim |

### Jira helpers

Ticket arguments accept a full key or a numeric ID, which is prefixed with `HYDRA-`. When an argument is omitted, most helpers derive the ticket from the current branch.

| Command | Behavior |
| --- | --- |
| `jsw` | List the current user's active sprint work items |
| `ji [--open] [ticket]` | View a ticket in the terminal or browser |
| `jit` | Print the current branch ticket and summary as `KEY: summary` |
| `jicl` | List comments on the branch ticket |
| `jicd <comment-id>` | Delete a comment from the branch ticket |
| `jis {i\|r\|t\|o}` | Transition to In Progress, Planned, Test, or To Do |
| `jic <body>` | Add a comment to the branch ticket |
| `mkb [ticket] [-c]` | Generate a `feat/` or `bugfix/` branch name; `-c` also switches to it |

### Azure DevOps and review helpers

`cpr` and the diff helpers use the Git setting `heiway.targetBranch`:

```bash
git config heiway.targetBranch <target-branch>
```

| Command | Behavior |
| --- | --- |
| `cpr [title]` | Create a squash PR against the configured target branch |
| `prl` | List PRs created by the current account and PRs where it is a reviewer |
| `pr [id]` | Open a PR by ID, or find the PR for the current branch |
| `prc [id]` | Check out a PR; without an argument, read the ID or URL from the macOS clipboard |
| `bul` | List the ten most recent pipeline builds |
| `bu [pr-id]` | Find and open the build associated with a PR |
| `eslint_pr` | Run ESLint on changed JS/TS files against the configured target branch |
| `biome_pr` | Run Biome on changed JS/TS files against the configured target branch |
| `generate_changelog` | Send the target-branch diff to the Gemini CLI for changelog generation |

## Herdr configuration

`herdr/config.toml` contains:

- Catppuccin theme with a blue `#89b4fa` accent
- Mouse capture and agent-aware sidebar rows
- `Ctrl-g` prefix
- Built-in `Ctrl-g` + `[` copy mode, `Ctrl-g` + `Shift-r` reload, and `Ctrl-g` + `g` session navigation
- `Ctrl-g` + `Alt-g` lazygit popup
- `Ctrl-g` + `f` hint-copy through `herdr-pluck`
- Direct Ctrl-H/J/K/L navigation through `vim-herdr-navigation`
- Agent sidebar rows for Claude (`$tok_out`, context, session, and weekly usage) and OpenCode (`$tok_out` and context)
- Resume agents on workspace restore

The global Ctrl-H/J/K/L bindings shadow shell readline Ctrl-L (clear screen) and Ctrl-K (kill line) in non-Vim panes. Set `HERDR_NAV_PASSTHROUGH_RE` when another TUI should receive those keys instead of Herdr.

### Project layouts

Herdr layouts are YAML files consumed by `herdr-spreader`. The repository currently contains one layout:

- `herdr/spreader/hydra-workplaces.yaml` — five tabs (`hydra-components`, `hydra-sb`, `hydra-ym`, `hydra-tm`, and `hydra-epod`), each with a focused Neovim pane and a lower shell pane

Run it with:

```bash
mux hydra-workplaces
```

`mux` resolves the installed `herdr-spreader` binary, applies the matching YAML file, and reports the available layout names when called without a project. The layout's `ratio: 0.7` keeps about 70% of the original pane; Herdr assigns the remainder to the new pane.

## Television configuration

`television/config.toml` sets `branch-task` as the default channel, keeps 200 per-channel history entries, uses a landscape layout with rounded borders, places the input bar at the top, and shows a 50% preview panel. Shell integration uses `Ctrl-t` for smart autocomplete and `Ctrl-r` for command history, with `files` as the fallback channel.

Configured shell triggers include aliases/environment variables, directories/files, Git diff/branch/log operations, Docker images, Git repositories, Azure DevOps PRs, and the Jira board.

### Channels

All channel files live in `television/cable/` and are discovered by the symlink in the installation step.

| Channel | Purpose and main actions |
| --- | --- |
| `branch-task` | Joins the current branch's Jira ticket with its Azure PR. `Ctrl-o` opens the item, `Ctrl-v` opens the matching PR, `Ctrl-n` creates a PR, `Ctrl-l` copies a link, `Ctrl-w` transitions Jira status, and `Ctrl-g` adds a PR link comment. Requires `acli`, `jq`, and `az`. |
| `acli-jira-board` | Three Jira views—my active, all my sprint tickets, and all team tickets—cycled with `Ctrl-s`. `Ctrl-o` opens, `Ctrl-w` transitions, `Ctrl-b` creates/checks out a branch, `Ctrl-y` copies ticket content, `Ctrl-l` copies a link, and `Ctrl-g` adds a PR link comment. Requires `acli` and `jq`; comment actions also use Azure CLI and `fzf`. |
| `az-devops-pr` | Lists non-draft Azure PRs. `Ctrl-o` opens, `Ctrl-n` creates, `Ctrl-b` checks out, `Ctrl-y` copies the ID, `Ctrl-u` copies the link, and `Ctrl-v` views builds. Requires `az`; creation and Jira-aware title filling also use `fzf` and `acli`. |

`jira-icons.jq` formats Jira statuses and issue types for the channel output. Clipboard actions are macOS-specific because the cables use the system clipboard utility.

## Neovim configuration

Neovim bootstraps lazy.nvim and imports LazyVim plus the local `nvim/lua/plugins/` specifications. LazyVim extras currently cover:

- Coding: LuaSnip, mini-surround, and yanky
- Editor: inc-rename, navic, and refactoring
- Languages/tools: Astro, Docker, Elixir, JSON, Markdown, Rust, Svelte, Tailwind, TypeScript, and Biome for TypeScript

### Local behavior and plugins

- Catppuccin **Macchiato** is the active theme.
- Claude Code integration is provided by `coder/claudecode.nvim`. `<leader>a` contains toggle, focus, resume, continue, model selection, buffer/file send, and diff accept/deny mappings.
- `jj` exits Insert mode; `,` is the local leader.
- Spell checking is enabled for US English and swap files are disabled.
- `nvim-navic` adds breadcrumbs to the status line; `git-blame.nvim` adds relative blame text there.
- `hunk.nvim` provides a vertical diff editor at `<leader>gH`; `vim-flog` and Fugitive provide Git history tooling.
- Neo-tree is positioned on the right.
- Snacks enables big-file handling, notifications, quick-file loading, status columns, and word navigation.
- `vim-matchup` improves matching-pair navigation.
- Tailwind LSP understands classes passed through `tv(...)` and `cva(...)` and excludes Markdown.
- TypeScript and JavaScript organize-imports are disabled in `vtsls` so Biome can handle them.
- LSP inlay hints are disabled.

The local `vim-herdr-navigation` spec loads the ignored plugin checkout after LazyVim's defaults so Ctrl-H/J/K/L can move between Neovim splits and Herdr panes. At a split edge, Neovim calls `herdr pane focus`; outside Herdr it falls back to tmux when available or normal window navigation.

## Oh My Pi policy extension

`omp/no-dotenv-policy.ts` is a custom Oh My Pi extension for Varlock-managed dotenv files. Its `tool_call` hook:

- allows `.env.schema` references but blocks other dotenv-file references
- blocks the `eval` tool because it can bypass path checks
- blocks tool calls containing clipboard commands that could expose secrets
- fails closed when tool input cannot be serialized

This is a tool-call boundary, not an OS sandbox. Use Varlock's `varlock run`/`varlock load` workflow for protected dotenv values. The extension is tracked as source; load it through the local Oh My Pi extension setup.

## Maintenance

- Neovim: run `:Lazy update`
- Herdr: use `herdr plugin list` to inspect plugins and `herdr update` to update Herdr
- Oh My Zsh: run `omz update`
- Television: update channel files and reload the application after configuration changes

Back up existing files before linking:

```bash
cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
cp -r "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
cp -r "$HOME/.config/herdr" "$HOME/.config/herdr.backup"
cp -r "$HOME/.config/television" "$HOME/.config/television.backup"
```

## Scope notes

This repository currently has no root-level `LICENSE` file. `nvim/LICENSE` belongs to the LazyVim starter configuration and is not a license declaration for the whole dotfiles repository. The `.claude/` and `.serena/` files that may exist in a local checkout are machine metadata and are not included in the setup above. `omp/no-dotenv-policy.ts` is tracked custom Oh My Pi policy source and is part of the repository configuration.
