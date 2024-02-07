#! /bin/sh

export TMUX_DOUBLE_BAR=false

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
  [ "$TMUX_DOUBLE_BAR" = "true" ] &&  tmux_double_status_bar
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

tmux_fuzzy() {
  TMUX_SESSION=$(zoxide query --list --score | fzf | awk '{print $2}')
  tmux_attach_or_create $TMUX_SESSION
}

run_tmux_on_shell_start() {
  if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    tmux_attach_or_create $HOME
  fi
}

tmux_double_status_bar() {
  [ -z "$(tmux show-option -gqv "status-format[6]")" ] && tmux set -g "status-format[6]" "$(tmux show-option -gqv "status-format[0]")"

  TMUX_STATUS_FORMAT="${TMUX_STATUS_FORMAT:-$(tmux show-option -gqv "status-format[6]")}"
  # NOTE: get left and right status bar setup
  STATUS_BAR_INFO="$(echo "${TMUX_STATUS_FORMAT}" | sed 's/:window-status-current-format//g' | sed 's/:window-status-format//g')"

  # NOTE: get windows info
  STATUS_BAR_WINDOWS="$(echo "${TMUX_STATUS_FORMAT}" | sed 's/#{T;=\/#{status-left-length}:status-left}//g' | sed 's/#{T;=\/#{status-right-length}:status-right}//g')"

  tmux set -g "status-format[0]" "${STATUS_BAR_INFO}"
  tmux set -g "status-format[1]" "${STATUS_BAR_WINDOWS}"
  tmux set -g status-justify centre
  tmux set -g status-position top 
  tmux set -g status 2

  # NOTE: Add borders even for one pane
  tmux set-window-option -g pane-border-status
  tmux set-window-option -g pane-border-format '' # Could add some data for each pane
}

alias t='tmux'
alias tns='tmux_new_session' 
alias ta='tmux_attach'
alias tn='tmux_attach_or_create' 
alias tf='tmux_fuzzy'
alias tk='t kill-session -t $(tmux_session_select)' # kill session

