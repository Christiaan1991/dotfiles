set -x PATH $PATH /usr/local/go/bin ~/go/bin
set -x TERM xterm-color
set -x GO111MODULE on
set -x PATH $PATH /usr/local/texlive/2024/bin/x86_64-linux

# android vars
set -x CAPACITOR_ANDROID_STUDIO_PATH /snap/android-studio/186/bin/studio.sh
set -x ANDROID_SDK_ROOT /home/ubuntu/Android/Sdk
set -x ANDROID_HOME /home/ubuntu/Android/Sdk
set -x ANDROID_SDK_ROOT /home/ubuntu/Android/Sdk

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
alias yubi="ykman oath accounts code --single | wl-copy"

# neovim shortcut
alias nn="nvim ."

# add git command for dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias lazydot='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

thefuck --alias | source

eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

alias bat="/usr/local/bat/bat"

# set JAVA_HOME to null, because it is set by lazy nvim
set -x JAVA_HOME
