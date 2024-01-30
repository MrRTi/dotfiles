#! /bin/bash

[ -n "${DOTFILES_PATH}" ] || export DOTFILES_PATH=~/.dotfiles

# NOTE: Add same configs for all shells
[ -f "$DOTFILES_PATH/.config/shell/.shell.sh" ] && . "$DOTFILES_PATH/.config/shell/.shell.sh" 

# NOTE: Source all functions
# shellcheck source=/dev/null
for f in "$DOTFILES_PATH"/.config/bash/extensions/*.sh; do . "$f"; done || return 

# NOTE: Shell opts
shopt -s autocd

# NOTE: Load extensions
add_file "/opt/homebrew/etc/profile.d/bash_completion.sh"
add_file "$HOME/.fzf.bash"
add_file "$HOME/yandex-cloud/completion.bash.inc"

eval "$(zoxide init bash)"

# NOTE: Run tmux session on start
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux_attach_or_create "$HOME"
fi
