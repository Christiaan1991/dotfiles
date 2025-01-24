set -x PATH $PATH /usr/local/go/bin ~/go/bin
set -x TERM xterm-color
set -x GO111MODULE on
set -x AWS_REGION us-east-1
set -x PATH $PATH /usr/local/texlive/2024/bin/x86_64-linux

# docker commands
alias dup="docker compose up -d"
alias down="docker compose down"
alias dops="docker ps"
alias dil="docker kill"
alias dip="docker image prune -a --filter " # followed by format: "until=2024-01-01T00:00:00"
alias dsp="docker system prune"

# gossm
alias gossm='/opt/gossm'

# golang test directory
alias got="go test ./..."

# create git tag
alias gt="git tag -l | sort -V | tail"

# yubikey shortcut
alias y="ykman oath accounts code --single | xclip -selection clip -rmlastnl"

# neovim shortcut
alias n="nvim ."

# add git command for dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias lazydot='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

thefuck --alias | source

eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

alias bat="/usr/local/bat/bat"

# set JAVA_HOME to null, because it is set by lazy nvim
set -x JAVA_HOME
