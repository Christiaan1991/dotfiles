# Dotfiles

My personal configuration files for macos managed with GNU Stow.

## Installation

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
