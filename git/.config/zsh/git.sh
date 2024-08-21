#!/usr/bin/env zsh

gwroot() {
  git worktree list | grep 'bare' | awk '{print $1}'
}

git_branch_query() {
  git brabch | fzf --print-query | head -n 1
}

# NOTE: add worktree
gwaq() {
  BRANCH=$(git_branch_query)
  echo "Creating worktree at ${BRANCH}"
  git worktree add -b "${BRANCH}" "$(gwroot)/${BRANCH}"
}

gwselect() {
  git worktree list | fzf | awk '{print $1}'
}

# NOTE: remove worktree
gwdq() {
  gwselect | xargs -0 git worktree remove
}

# NOTE: remove worktree
gwdqf() {
  gwselect | xargs -0 git worktree remove --force
}

# NOTE: switch to worktree
gws() {
  NEW_PATH=$(git worktree list | awk '{print ($3 == "" ? "(root)" : $3), $1}' | fzf | awk '{print $2}')
  cd "$NEW_PATH" || exit
}
