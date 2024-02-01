#! /bin/sh

alias gw='g worktree'
alias gwl='gw list'

gwroot() {
  git worktree list | grep 'bare' | awk '{print $1}'
}

# NOTE: add worktree
alias gwa='gb | fzf --print-query | head -n 1 | xargs -I@ git worktree add -b @ $(gwroot)/@'

gwselect() {
  git worktree list | fzf | awk '{print $1}'
}

# NOTE: remove worktree
gwd() {
  gwselect | xargs git worktree remove
}

# NOTE: remove worktree
gwdf() {
  gwselect | xargs git worktree remove --force
}

# NOTE: switch to worktree
gws() {
  NEW_PATH=$(git worktree list | awk '{print ($3 == "" ? "(root)" : $3), $1}' | fzf | awk '{print $2}')
  cd "$NEW_PATH" || exit
}
