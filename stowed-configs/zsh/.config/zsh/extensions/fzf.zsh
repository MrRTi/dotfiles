#!/usr/bin/env zsh

fzf_with_theme() {
  export FZF_DEFAULT_OPTS=$(fzf_theme)
  fzf
}
# alias fzf="fzf_with_theme"
