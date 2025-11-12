# 🧩 Dotfiles

My personal configuration files for macOS managed with GNU Stow.

## What's Included

This repository contains configurations for:

- **Kitty** - A modern, GPU-accelerated terminal emulator with multiple color themes (Catppuccin, Kanagawa variants)
- **Neovim** - A powerful text editor for coding using LazyVim with additional plugins for development, testing, and Git integration
- **OpenCode** - AI-powered coding assistant with custom agents for documentation writing and code review
- **Starship** - A fast, customizable command-line prompt that shows useful information like the current directory, Git branch, and programming language versions
- **Zellij** - A terminal multiplexer that lets you split your terminal into multiple panes and tabs, includes a custom dev layout
- **Zsh** - A shell (command-line interface) with advanced features and custom settings

## 📁 Directory Structure

```
dotfiles/
│
├── kitty/                          # Kitty terminal emulator
│   └── .config/kitty/
│       ├── kitty.conf              # Main configuration
│       ├── kitty-catppuccin.conf   # Catppuccin theme
│       ├── kitty-kanagawa.conf     # Kanagawa theme
│       ├── kitty-kanagawa-dragon.conf  # Kanagawa Dragon variant
│       └── kitty-kanagawa-light.conf   # Kanagawa Light variant
│
├── nvim/                           # Neovim text editor
│   └── .config/nvim/
│       ├── init.lua                # Entry point
│       ├── lua/
│       │   ├── config/             # Core configuration
│       │   │   ├── autocmds.lua    # Auto-commands (automatic actions)
│       │   │   ├── keymaps.lua     # Keyboard shortcuts
│       │   │   ├── lazy.lua        # Plugin manager setup
│       │   │   └── options.lua     # Editor settings
│       │   └── plugins/            # Plugin configurations
│       │       ├── bufferline.lua  # Tab/buffer line at the top
│       │       ├── catppuccin.lua  # Catppuccin color theme
│       │       ├── core.lua        # Essential plugins
│       │       ├── gitsigns.lua    # Git integration
│       │       ├── lualine.lua     # Status line at the bottom
│       │       ├── markdown.lua    # Markdown editing support
│       │       ├── mason.lua       # Tool installer (LSP, formatters, linters)
│       │       ├── neotest.lua     # Testing framework integration
│       │       ├── opencode.lua    # OpenCode integration
│       │       └── snacks.lua      # Snacks plugin collection
│       ├── .gitignore
│       ├── .neoconf.json           # Configuration metadata
│       ├── coc-settings.json       # Conquer of Completion settings
│       ├── lazyvim.json            # LazyVim configuration
│       └── stylua.toml             # Lua code formatter settings
│
├── opencode/                       # OpenCode AI assistant
│   └── .config/opencode/
│       ├── opencode.json           # Main configuration (theme, model)
│       ├── package.json            # Plugin dependencies
│       ├── .gitignore              # Excludes node_modules
│       ├── agent/                  # Custom agent configurations
│       │   ├── documentation-writer.md  # Documentation writing agent
│       │   └── review.md           # Code review agent
│       └── command/                # Custom slash commands
│
├── starship/                       # Starship prompt
│   └── .config/
│       └── starship.toml           # Prompt customization
│
├── zellij/                         # Zellij terminal multiplexer
│   └── .config/zellij/
│       ├── config.kdl              # Main configuration
│       ├── layout/
│       │   └── dev.kdl             # Development workspace layout
│       └── themes/
│           └── catppuccin.kdl      # Catppuccin color theme
│
├── zsh/                            # Zsh shell
│   └── .zshrc                      # Configuration and aliases
│
├── .gitignore                      # Git ignore patterns
├── .stow-local-ignore              # Files to ignore when stowing
└── README.md                       # This file
```

## Requirements

- [GNU Stow](https://www.gnu.org/software/stow/) - For managing dotfiles
- [Neovim](https://neovim.io/) - For nvim config
- [Kitty](https://sw.kovidgoyal.net/kitty/) - For kitty config
- [OpenCode](https://opencode.ai/) - For OpenCode AI assistant
- [Starship](https://starship.rs/) - For starship prompt
- [Zellij](https://zellij.dev/) - For zellij config
- [Zsh](https://www.zsh.org/) - For zsh config

## Installation

### Installing GNU Stow

**macOS:**
```bash
brew install stow
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt install stow
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install stow
```

**Linux (Arch):**
```bash
sudo pacman -S stow
```

### Setting Up Dotfiles

1. Clone this repository:
   ```bash
   git clone <repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Stow packages you want:
   ```bash
   stow kitty    # Install kitty config
   stow nvim     # Install nvim config
   stow opencode # Install OpenCode config
   stow zsh      # Install zsh config
   stow starship # Install starship config
   stow zellij   # Install zellij config
   ```

3. Or install all at once:
   ```bash
   stow */
   ```

## Uninstall

To remove configurations:
```bash
stow -D kitty nvim opencode zsh starship zellij
```
