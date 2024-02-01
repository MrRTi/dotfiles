#! /bin/sh

add_file "$HOME/yandex-cloud/path.bash.inc"
add_file "$HOME/yandex-cloud/completion.zsh.inc"

# NOTE: show vms
ycls() {
 yc compute instance list --format json | jq --raw-output '.[] | "\(.name) \(.status)"'
}

# NOTE: select vm
ycs() {
  ycls | fzf | awk '{print $1}'
}

alias ycup='ycs | xargs yc compute instance start --name'
alias ycstop='ycs | xargs yc compute instance stop --name'

