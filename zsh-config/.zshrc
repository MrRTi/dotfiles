[[ ! -z "${DOTFILES_PATH}" ]] || export DOTFILES_PATH=~/.dotfiles

zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 1

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

autoload -U compinit && compinit
[[ -f $DOTFILES_PATH/zsh-config/.aliases ]] && . $DOTFILES_PATH/zsh-config/.aliases

eval "$(starship init zsh)"

source $DOTFILES_PATH/antigen/antigen.zsh
antigen init $DOTFILES_PATH/zsh-config/.antigenrc

[ -f ~/yandex-cloud/path.bash.inc ] && source ~/yandex-cloud/path.bash.inc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export DOCKER_DEFAULT_PLATFORM=linux/amd64
