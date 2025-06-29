# 🚀 Personal Dotfiles

A collection of configuration files for a modern development environment featuring Tmux, Neovim (LazyVim), and custom shell utilities.

## 📁 Structure

```
├── nvim/                   # Neovim configuration (LazyVim-based)
├── tmux/                   # Tmux configuration and utilities
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

### Tmux Configuration
- **Theme**: Catppuccin with custom status line
- **Key Features**:
  - Custom prefix key (`Ctrl-g`)
  - Mouse support enabled
  - Vi-style key bindings
  - Integrated vim-tmux navigation
  - Lazygit popup integration
  - Clipboard integration (macOS)
  - Plugin management with TPM

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
- [Tmux](https://github.com/tmux/tmux)

### Quick Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/.config/dotfiles
   cd ~/.config/dotfiles
   ```

2. **Install dependencies**:
   ```bash
   # Install Homebrew packages
   brew install neovim tmux starship fnm
   
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
   
   # Tmux
   mkdir -p ~/.config/tmux
   ln -sf ~/.config/dotfiles/tmux/* ~/.config/tmux/
   
   # Zsh
   ln -sf ~/.config/dotfiles/.zshrc ~/.zshrc
   ```

4. **Install Tmux Plugin Manager**:
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
   ```

5. **Install tmux plugins**:
   - Start tmux: `tmux`
   - Press `prefix + I` (Ctrl-g + I) to install plugins

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

### Tmux Shortcuts
- `prefix + r` - Reload tmux configuration
- `prefix + g` - Open lazygit in a popup
- `Ctrl + h/j/k/l` - Navigate between vim and tmux panes seamlessly

### Neovim Enhancements
- `jj` - Exit insert mode
- `,` - Local leader key for additional mappings
- Integrated GitHub Copilot for AI assistance
- Git blame in status line
- File tree on the right side

## 🎨 Customization

### Tmux Themes
The configuration includes both Catppuccin and Dracula themes. To switch themes:

1. Edit `tmux/tmux.conf`
2. Comment/uncomment the desired theme plugin
3. Reload tmux configuration

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
- **Tmux**: Press `prefix + U` to update tmux plugins
- **Oh My Zsh**: Run `omz update`

### Backup
Before making changes, consider backing up your existing configurations:
```bash
cp ~/.zshrc ~/.zshrc.backup
cp -r ~/.config/nvim ~/.config/nvim.backup
cp -r ~/.config/tmux ~/.config/tmux.backup
```

## 📋 Requirements

- **Neovim**: >= 0.9.0
- **Tmux**: >= 3.0
- **Zsh**: >= 5.0
- **Node.js**: Latest LTS (managed via fnm)
- **Git**: >= 2.0

## 🤝 Contributing

Feel free to fork this repository and adapt it to your needs. If you have improvements or bug fixes, pull requests are welcome!

## 📄 License

This configuration is open source and available under the [MIT License](LICENSE).
