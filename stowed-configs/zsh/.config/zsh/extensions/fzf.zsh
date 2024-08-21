#!/usr/bin/env zsh

fzf_with_theme() {
  export FZF_DEFAULT_OPTS=$(fzf_theme)
  fzf
}

# Open in tmux popup if on tmux, otherwise use --height mode
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'
