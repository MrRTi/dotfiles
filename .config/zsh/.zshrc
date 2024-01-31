#! /bin/zsh

[ -n "${DOTFILES_PATH}" ] || export DOTFILES_PATH=~/.dotfiles

# NOTE: Add same configs for all shells
[ -f "$DOTFILES_PATH/.config/shell/.shell.sh" ] && . "$DOTFILES_PATH/.config/shell/.shell.sh"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

for f in $DOTFILES_PATH/.config/zsh/extensions/*.sh; do source $f; done || return
add_file ~/.fzf.zsh

# NOTE: vim mode
bindkey -v

setopt auto_cd

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# NOTE: Run tmux session on start
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux_attach_or_create $HOME
fi

eval "$(zoxide init zsh)"
