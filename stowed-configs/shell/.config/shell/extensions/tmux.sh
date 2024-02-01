#! /bin/sh

# NOTE: Tmux automaticaly replacing . to _ if session name starts with .
# It prevents to find session for folder using folder name if folder have . as first symbol
# We will use this conversion to have consistent session names on attach and create
replace_first_dot_with_underscore() {
  basename "$1" | sed "s/^\./_/g"
}

# NOTE: Tmux attach on switch if already in tmux
tmux_switch() {
  if [ -n "${TMUX}" ]; then 
    tmux switch -t "$1"
  else
    tmux attach -t "$1"
  fi
}

# NOTE: Tmux new session in specified or current folder
tmux_new_session() {
  SESSION_PATH=${1:-$(pwd)}
  SESSION_NAME=$(replace_first_dot_with_underscore "${SESSION_PATH}")
  TMUX='' tmux new -c "${SESSION_PATH}" -s "${SESSION_NAME}" -d 
  tmux_switch "${SESSION_NAME}"
}

tmux_session_select() {
  tmux ls -F "#{session_name}" | fzf
}

# NOTE: Attach to existing tmux session. Using fzf to select session
tmux_attach() {
  tmux_switch "$(tmux_session_select)" 
}

# NOTE: Attach OR create new session in specified or current folder
tmux_attach_or_create() {
  PWD_FOR_SESSION_NAME=$(replace_first_dot_with_underscore "$(pwd)")
  tmux_switch "${1:-$PWD_FOR_SESSION_NAME}" 2>/dev/null || tmux_new_session "${1:-$(pwd)}"
}

run_tmux_on_shell_start() {
  if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    tmux_attach_or_create $HOME
  fi
}

alias t='tmux'
alias tns='tmux_new_session' 
alias ta='tmux_attach'
alias tn='tmux_attach_or_create' 
alias tk='t kill-session -t $(tmux_session_select)' # kill session

