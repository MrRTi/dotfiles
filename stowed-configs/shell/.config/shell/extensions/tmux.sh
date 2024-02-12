#! /bin/sh

run_tmux_on_shell_start() {
  if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    tmux_sessionizer $HOME
  fi
}

alias t='tmux'
alias tn='tmux_sessionizer' 
