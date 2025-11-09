# Dotfiles

My personal configuration files for macos managed with GNU Stow.

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
stow -D kitty nvim zsh starship zellij
```

## Structure

- `kitty/` - Kitty terminal configuration with multiple theme variants
- `nvim/` - Neovim configuration (LazyVim based)
- `starship/` - Starship prompt configuration
- `zellij/` - Zellij terminal multiplexer configuration and layouts
- `zsh/` - Zsh shell configuration

## Directory Structure Overview

```
dotfiles/
│
├── kitty/                          # Kitty terminal emulator configuration
│   └── .config/kitty/
│       ├── kitty.conf              # Main kitty configuration
│       ├── kitty-catppuccin.conf   # Catppuccin theme
│       ├── kitty-kanagawa.conf     # Kanagawa theme
│       ├── kitty-kanagawa-dragon.conf  # Kanagawa Dragon variant
│       └── kitty-kanagawa-light.conf   # Kanagawa Light variant
│
├── nvim/                           # Neovim text editor configuration
│   └── .config/nvim/
│       ├── init.lua                # Entry point for Neovim config
│       ├── lua/
│       │   ├── config/             # Core configuration files
│       │   │   ├── autocmds.lua    # Auto-commands (automatic actions)
│       │   │   ├── keymaps.lua     # Keyboard shortcuts
│       │   │   ├── lazy.lua        # Lazy plugin manager setup
│       │   │   └── options.lua     # Editor settings and options
│       │   └── plugins/            # Plugin configurations
│       │       ├── bufferline.lua  # Tab/buffer line at the top
│       │       ├── catppuccin.lua  # Catppuccin color theme
│       │       ├── core.lua        # Essential plugins
│       │       ├── gitsigns.lua    # Git integration in the editor
│       │       ├── lualine.lua     # Status line at the bottom
│       │       ├── markdown.lua    # Markdown editing support
│       │       ├── mason.lua       # Tool installer (LSP, formatters, linters)
│       │       ├── neotest.lua     # Testing framework integration
│       │       ├── opencode.lua    # OpenCode integration
│       │       └── snacks.lua      # Snacks plugin collection
│       ├── .gitignore
│       ├── .neoconf.json           # Neovim configuration metadata
│       ├── coc-settings.json       # Conquer of Completion settings
│       ├── lazyvim.json            # LazyVim configuration
│       └── stylua.toml             # Lua code formatter settings
│
├── starship/                       # Starship prompt configuration
│   └── .config/
│       └── starship.toml           # Prompt customization settings
│
├── zellij/                         # Zellij terminal multiplexer configuration
│   └── .config/zellij/
│       ├── config.kdl              # Main zellij configuration
│       ├── layout/
│       │   └── dev.kdl             # Development workspace layout
│       └── themes/
│           └── catppuccin.kdl      # Catppuccin color theme
│
├── zsh/                            # Zsh shell configuration
│   └── .zshrc                      # Shell configuration and aliases
│
├── .gitignore                      # Git ignore patterns
├── .stow-local-ignore              # Files to ignore when stowing
└── README.md                       # This file
```

### What Each Configuration Does

**Kitty**: A modern, GPU-accelerated terminal emulator. The configuration includes multiple color themes you can switch between.

**Neovim**: A powerful text editor for coding. This setup uses LazyVim (a pre-configured setup) with additional plugins for development, testing, and Git integration.

**Starship**: A fast, customizable command-line prompt that shows useful information like the current directory, Git branch, and programming language versions.

**Zellij**: A terminal multiplexer that lets you split your terminal into multiple panes and tabs. Includes a custom layout for development work.

**Zsh**: A shell (command-line interface) with advanced features. The `.zshrc` file contains custom settings and shortcuts.

## Requirements

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Neovim](https://neovim.io/) (for nvim config)
- [Kitty](https://sw.kovidgoyal.net/kitty/) (for kitty config)
- [Starship](https://starship.rs/) (for starship prompt)
- [Zellij](https://zellij.dev/) (for zellij config)
- [Zsh](https://www.zsh.org/) (for zsh config)

## Notes

- The nvim configuration uses LazyVim and includes custom plugins for development
- Kitty includes multiple theme files (Catppuccin, Kanagawa variants)
- Zellij includes a custom dev layout
