
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(
  aws
  azure
  git
  golang
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
)

source $ZSH/oh-my-zsh.sh

# fastfetch. Will be disabled if above colorscript was chosen to install
# fastfetch -c $HOME/.config/fastfetch/config.jsonc

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# Set-up fnm
eval "$(fnm env --use-on-cd)"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# export MANPATH="/usr/local/man:$MANPATH"
export PATH=/usr/local/share/npm/bin:$PATH

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"


# Load Angular CLI autocompletion.
# source <(ng completion script)

# fnm
FNM_PATH="/Users/chris/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/chris/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

# pnpm
export PNPM_HOME="/Users/chris/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# awslogin shortcut
alias awslogin="source ~/scripts/awslogin"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# starship Set-up
eval "$(zellij setup --generate-auto-start zsh)"
eval "$(starship init zsh)"

# opencode
export PATH=/Users/chris/.opencode/bin:$PATH
