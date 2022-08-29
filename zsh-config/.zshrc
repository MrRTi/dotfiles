[[ ! -z "${DOTFILES_PATH}" ]] || export DOTFILES_PATH=~/.dotfiles

zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 1

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

autoload -U compinit && compinit
[[ -f $DOTFILES_PATH/zsh-config/.aliases ]] && . $DOTFILES_PATH/zsh-config/.aliases

export STARSHIP_CONFIG=$DOTFILES_PATH/starship.toml
eval "$(starship init zsh)"

source $DOTFILES_PATH/antigen/antigen.zsh
antigen init $DOTFILES_PATH/zsh-config/.antigenrc

export DOCKER_DEFAULT_PLATFORM=linux/amd64
