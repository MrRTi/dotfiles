#! bin/bash

# NOTE: Tmux automaticaly replacing . to _ if session name starts with .
# It prevents to find session for folder using folder name if folder have . as first symbol
# We will use this conversion to have consistent session names on attach and create
function replace_first_dot_with_underscore() {
  basename $1 | sed "s/^\./_/g"
}

# NOTE: Tmux attach on switch if already in tmux
function tmux_switch() {
  if [[ ! -z "${TMUX}" ]] then 
    tmux switch -t "$1"
  else
    tmux attach -t "$1"
  fi
}

# NOTE: Tmux new session in specified or current folder
function tmux_new_session() {
  SESSION_PATH=${1:-$(pwd)}
  SESSION_NAME=$(replace_first_dot_with_underscore ${SESSION_PATH})
  TMUX= tmux new -c ${SESSION_PATH} -s ${SESSION_NAME} -d 
  tmux_switch ${SESSION_NAME}
}

# NOTE: Attach to existing tmux session. Using fzf to select session
function tmux_attach() {
  TMUX_SESSION=$(tmux ls -F "#{session_name}" | fzf)
  tmux_switch $TMUX_SESSION 
}

# NOTE: Attach OR create new session in specified or current folder
function tmux_attach_or_create() {
  PWD_FOR_SESSION_NAME=$(replace_first_dot_with_underscore $(pwd))
  tmux_switch ${1:-$PWD_FOR_SESSION_NAME} 2>/dev/null || tmux_new_session ${1:-$(pwd)}
}

alias t='tmux'
alias tns='tmux_new_session' 
alias ta='tmux_attach'
alias tn='tmux_attach_or_create' 
alias tk='t kill-session -t $(tsn)' # kill session

