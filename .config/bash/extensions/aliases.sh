#! bin/bash

# navigation
alias ..='cd ..'
alias ~~='cd ~/'

alias bashr='. ~/.bashrc'

alias md='mkdir'

alias ll='lsla'

alias batp='bat --style=plain --paging=never'
alias batn='bat --paging=never'

# brew
alias brew="arch -arm64e /opt/homebrew/bin/brew" # arm64e homebrew path (m1)
alias ibrew="arch -x86_64 /usr/local/bin/brew"    # x86_64 homebrew path (intel)

alias vim='nvim'
alias v='vim'
alias vf='v .'

alias c='clear'

alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'

# docker-compose
alias d='docker'
alias dc='d compose'
alias dcr='dc run --rm --use-aliases'
alias dcrs='dcr --service-ports --use-aliases'

# git
alias g='git'
alias gs='g status '
alias gc='g commit'
alias gcv='gc -v'
alias gcm='gc -m'
alias gca='gc --ammend'
alias gcane='gc --amend --no-edit'
alias guc='g reset HEAD~'
alias gfrs='g flow release start'
alias gfrf='g flow release finish'
alias ga='g add'
alias gco='g checkout'
alias gb='g branch'
alias gbmv='g branch -M'
alias gbrm='g branch -D'
alias grup='g remote update'
alias gup='g pull'
alias gupr='g pull -r'
alias gp='g push'
alias gpt='gp && gp --tags'
alias gpuo='gp -u origin'
alias gpfo='gp -f origin'
alias glol='g log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias gcof='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1}"  | xargs git checkout'
alias gcofd='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1} | delta" --pointer="" | xargs git checkout'

# git worktree
alias gw='g worktree'
alias gwl='gw list'
alias gwroot='gwl | grep bare | awk '\''{print $1}'\'''
alias gwa='gb | fzf --print-query | head -n 1 | xargs -I@ git worktree add -b @ $(gwroot)/@'
alias gwd='gwl | fzf | awk '\''{print $1}'\'' | xargs git worktree remove'
alias gwdf='gwl | fzf | awk '\''{print $1}'\'' | xargs git worktree remove --force'
alias gws='cd $(gwl | awk '\''{print ($3 == "" ? "(root)" : $3), $1}'\'' | fzf | awk '\''{print $2}'\'')' 

# terraform
alias tf='terraform'
alias tfi='tf init'
alias tfp='tf plan'
alias tfa='tf apply'

# Kubernetes
alias kubefp='export KUBE_NAMESPACE=$(kubefn) && kubectl get pods --field-selector=status.phase=Running -n ${KUBE_NAMESPACE:-default} | fzf | awk '\''{print $1}'\'''
alias kubelogs='kubefp | xargs kubectl logs'
alias kubebash='kubeexec /bin/bash'
alias kubefn='kubectl get namespace | fzf | awk '\''{print $1}'\'''
alias kubeexec='kubefp | xargs -o -I@ kubectl exec -ti @ -c netology-rails -n ${KUBE_NAMESPACE:-default} -- '

# yandex cloud
alias ycls='yc compute instance list --format json | jq --raw-output '\''.[] | "\(.name) \(.status)"'\'''
alias ycfn='ycls | fzf | awk '\''{print $1}'\'''
alias ycup=' ycfn | xargs yc compute instance start --name'
alias ycstop=' ycfn | xargs yc compute instance stop --name'

# brew
alias rebrew='brew bundle --file ${DOTFILES_PATH}/Brewfile'
alias brewdump='brew bundle dump --force --file=${DOTFILES_PATH}/Brewfile'

# home-mamager
alias hm='home-manager'
alias hmb='hm build'
alias hms='hm switch'
