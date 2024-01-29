#! /bin/bash

[ -n "${DOTFILES_PATH}" ] || export DOTFILES_PATH=~/.dotfiles

# NOTE: Add same configs for all shells
# shellcheck source=/dev/null
[ -f "$DOTFILES_PATH/.config/shell/.shell.sh" ] && . "$DOTFILES_PATH/.config/shell/.shell.sh"

# NOTE: Source all functions
# shellcheck source=/dev/null
for f in "$DOTFILES_PATH"/.config/bash/extensions/*.sh; do . "$f"; done

# NOTE: Shell opts
shopt -s autocd

# NOTE: Load extensions
# shellcheck source=/dev/null
[ -f "/opt/homebrew/etc/profile.d/bash_completion.sh" ] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
# shellcheck source=/dev/null
[ -f "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"
# shellcheck source=/dev/null
[ -f "$HOME/yandex-cloud/completion.bash.inc" ] && . "$HOME/yandex-cloud/completion.bash.inc"

# NOTE: Run tmux session on start
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux_attach_or_create "$HOME"
fi
