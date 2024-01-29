#! /bin/sh

alias ..='cd ..'
alias md='mkdir -pv'

alias batp='bat --style=plain --paging=never'
alias batn='bat --paging=never'

# NOTE: brew
alias rebrew='brew bundle --file ${DOTFILES_PATH}/Brewfile'
alias brewdump='brew bundle dump --force --file=${DOTFILES_PATH}/Brewfile'
# NOTE: multi arch aliases for apple silicon
alias brew="arch -arm64e /opt/homebrew/bin/brew" # arm64e homebrew path (m1)
alias ibrew="arch -x86_64 /usr/local/bin/brew"    # x86_64 homebrew path (intel)

alias vim='nvim'
alias v='vim'
alias vf='v .'

alias c='clear'

# NOTE: fuzzy find in tldr
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'

# NOTE: docker-compose
alias d='docker'
alias dc='d compose'
alias dcr='dc run --rm --use-aliases'
alias dcrs='dcr --service-ports --use-aliases'

# NOTE: git
alias g='git'
alias gs='g status '
alias gc='g commit'
alias ga='g add'
alias gco='g checkout'
alias gb='g branch'
alias grup='g remote update'
alias glol='g log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'

# NOTE: terraform
alias tf='terraform'

# NOTE: home-mamager
alias hm='home-manager'
alias hmb='hm build'
alias hms='hm switch'
