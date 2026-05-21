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
  zsh-vi-mode
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

# aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias n="nvim"

# awslogin shortcut
alias awslogin="source ~/scripts/awslogin"

# starship Set-up
eval "$(zellij setup --generate-auto-start zsh)"
eval "$(starship init zsh)"

# opencode
export PATH=/Users/chris/.opencode/bin:$PATH

# set GOPRIVATE for lib access
export GOPRIVATE=github.com/pwc-nl-taxtechnology-ondemand,github.com/pwc-nl-taxtechnology-shared-org

# haas setup
[ -s "/Users/cpost003/.haas/haas.sh" ] && source "/Users/cpost003/.haas/haas.sh"

# Load OpenCode secrets, use as example
if [ -f "$HOME/.config/opencode/secrets.json" ]; then
    export SONARQUBE_TOKEN=$(grep -o '"SONARQUBE_TOKEN":[^,}]*' "$HOME/.config/opencode/secrets.json" | cut -d'"' -f4)
fi

# nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# dotnet
export PATH=$PATH:/usr/local/share/dotnet

# Added by sonarqube-cli installer
export PATH="$HOME/.local/share/sonarqube-cli/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
