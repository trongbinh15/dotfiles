# 🚀 Personal Dotfiles

A collection of configuration files for a modern development environment featuring Herdr, Neovim (LazyVim), and custom shell utilities.

## 📁 Structure

```
├── nvim/                   # Neovim configuration (LazyVim-based)
├── herdr/                  # Herdr configuration, plugins, and project layouts
├── .zshrc                  # Zsh shell configuration
└── README.md              # This file
```

## 🛠️ Tools & Technologies

### Neovim Configuration
- **Framework**: [LazyVim](https://github.com/LazyVim/LazyVim) - Modern Neovim configuration
- **Theme**: Catppuccin Mocha
- **Key Features**:
  - AI integration with GitHub Copilot
  - Enhanced LSP support for TypeScript, JavaScript, Elixir, and more
  - Git integration with blame and visual diff tools
  - Custom keybindings and productivity plugins
  - Spell checking and autocomplete

### Herdr Configuration
- **Theme**: Catppuccin
- **Key Features**:
  - Custom prefix key (`Ctrl-g`)
  - Lazygit popup (`prefix + alt + g` — plain `prefix+g` is herdr's built-in `goto`/session navigator, kept as-is)
  - Mouse-native, agent-aware panes/tabs/workspaces
  - Seamless `Ctrl-h/j/k/l` nav between Neovim splits and herdr panes via the [vim-herdr-navigation](https://github.com/paulbkim-dev/vim-herdr-navigation) plugin (vendored at `herdr/plugins/vim-herdr-navigation`, gitignored — clone step below)
    - Requires `jq` (`brew install jq`) for Vim-detection; without it the keys still move herdr panes, just with no Vim awareness.
    - Tradeoff: shadows shell readline `Ctrl-L` (clear screen) / `Ctrl-K` (kill-line) in non-Vim panes.
- **Known gaps vs old tmux setup** (not yet ported, no confirmed herdr equivalent):
  - tmux-fingers quick-jump (`i`)
  - status bar position/format (herdr uses a sidebar instead)

### Project Layouts
Herdr has no built-in project-file format, so layouts are declared in YAML and applied via the [herdr-spreader](https://github.com/yuk1ty/herdr-spreader) plugin (`herdr plugin install yuk1ty/herdr-spreader`).
- **Layouts**: `herdr/spreader/*.yaml` — one file per project (`cine`, `hydra-workplaces`, `omni-workplaces`)
- **Launch**: `mux <project>` shell function (defined in `.zshrc`) — resolves the plugin's built binary and runs `herdr-spreader apply --file herdr/spreader/<project>.yaml`
- Schema: `workspaces` → `tabs` → `panes`, with `split`/`ratio`/`cwd`/`command`/`wait_for` per pane — see the plugin README for the full reference
- Note: herdr's `pane split --ratio` sizes the *original* pane, not the new one — set `ratio` to what you want the first/main pane to keep

### Shell Configuration (Zsh)
- **Framework**: Oh My Zsh
- **Prompt**: Starship
- **Key Features**:
  - Smart package manager detection (`pi`, `pd`, `pb` functions)
  - Azure DevOps integration for PR management
  - Custom aliases for common development tasks
  - Node.js version management with fnm

## 🚀 Installation

### Prerequisites
- macOS (some configurations are macOS-specific)
- [Homebrew](https://brew.sh/)
- [Node.js](https://nodejs.org/) (managed via fnm)
- [Neovim](https://neovim.io/) (>= 0.9.0)
- [Herdr](https://herdr.dev/)

### Quick Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/.config/dotfiles
   cd ~/.config/dotfiles
   ```

2. **Install dependencies**:
   ```bash
   # Install Homebrew packages
   brew install neovim starship fnm
   
   # Install Oh My Zsh
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   
   # Install zsh plugins
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting
   ```

3. **Create symlinks**:
   ```bash
   # Neovim
   ln -sf ~/.config/dotfiles/nvim ~/.config/nvim
   
   # Zsh
   ln -sf ~/.config/dotfiles/.zshrc ~/.zshrc
   ```

4. **Herdr**:
   ```bash
   curl -fsSL https://herdr.dev/install.sh | sh
   mkdir -p ~/.config/herdr
   ln -sf ~/.config/dotfiles/herdr/config.toml ~/.config/herdr/config.toml

   # vim-herdr-navigation plugin (Ctrl-h/j/k/l across nvim splits + herdr panes)
   git clone https://github.com/paulbkim-dev/vim-herdr-navigation ~/.config/dotfiles/herdr/plugins/vim-herdr-navigation
   herdr plugin link ~/.config/dotfiles/herdr/plugins/vim-herdr-navigation
   brew install jq   # optional, enables Vim-aware forwarding

   # herdr-spreader plugin (project layouts, replaces tmuxinator — see herdr/spreader/*.yaml)
   herdr plugin install yuk1ty/herdr-spreader -y

   herdr
   ```

## ⚡ Key Features

### Smart Package Manager Functions
- `pi` - Auto-detects and runs the appropriate install command (npm, yarn, pnpm)
- `pd` - Auto-detects and runs the appropriate dev command
- `pb` - Auto-detects and runs the appropriate build command

### Azure DevOps Integration
- `cpr <title>` - Create a pull request with the configured target branch
- `prl` - List your pull requests (created and reviewing)
- `pr [id]` - Open a pull request (current branch or specific ID)
- `prc <id>` - Checkout a pull request branch
- `bu [pr_id]` - Open build logs for a PR

### Herdr Shortcuts
- `prefix + shift + r` - Reload herdr configuration
- `prefix + alt + g` - Open lazygit in a popup
- `Ctrl + h/j/k/l` - Navigate between vim and herdr panes seamlessly

### Project Layouts
- `mux <project>` - Spin up a project's herdr workspace/tabs/panes from `herdr/spreader/<project>.yaml` (e.g. `mux cine`)

### Neovim Enhancements
- `jj` - Exit insert mode
- `,` - Local leader key for additional mappings
- Integrated GitHub Copilot for AI assistance
- Git blame in status line
- File tree on the right side

## 🎨 Customization

### Herdr Themes
The configuration uses the Catppuccin theme. To switch themes:

1. Edit the `[theme]` section in `herdr/config.toml`
2. Reload with `prefix + shift + r`, or `herdr server reload-config`

### Neovim Plugins
Neovim uses LazyVim's plugin management. To add new plugins:

1. Create a new file in `nvim/lua/plugins/`
2. Follow LazyVim's plugin specification format
3. Restart Neovim

### Shell Aliases
Add custom aliases to `.zshrc` in the aliases section or create project-specific functions.

## 🔧 Maintenance

### Updating Plugins
- **Neovim**: Run `:Lazy update` in Neovim
- **Herdr**: `herdr plugin` subcommands (`herdr plugin list`, `herdr update`)
- **Oh My Zsh**: Run `omz update`

### Backup
Before making changes, consider backing up your existing configurations:
```bash
cp ~/.zshrc ~/.zshrc.backup
cp -r ~/.config/nvim ~/.config/nvim.backup
cp -r ~/.config/herdr ~/.config/herdr.backup
```

## 📋 Requirements

- **Neovim**: >= 0.9.0
- **Herdr**: latest stable
- **Zsh**: >= 5.0
- **Node.js**: Latest LTS (managed via fnm)
- **Git**: >= 2.0

## 🤝 Contributing

Feel free to fork this repository and adapt it to your needs. If you have improvements or bug fixes, pull requests are welcome!

## 📄 License

This configuration is open source and available under the [MIT License](LICENSE).
