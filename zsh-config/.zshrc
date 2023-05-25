[[ ! -z "${DOTFILES_PATH}" ]] || export DOTFILES_PATH=~/.dotfiles

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

[[ -f $DOTFILES_PATH/zsh-config/.aliases ]] && . $DOTFILES_PATH/zsh-config/.aliases
[[ -f $DOTFILES_PATH/zsh-config/git_helper ]] && . $DOTFILES_PATH/zsh-config/git_helper

[ -f ~/yandex-cloud/path.bash.inc ] && source ~/yandex-cloud/path.bash.inc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -d "/home/linuxbrew/.linuxbrew/" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load

zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins.zsh
[[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt
fpath+=(${ZDOTDIR:-~}/.antidote)
autoload -Uz $fpath[-1]/antidote
if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
  (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
fi
source $zsh_plugins

autoload -Uz compinit
ZSH_COMPDUMP=${ZSH_COMPDUMP:-${ZDOTDIR:-~}/.zcompdump}

# cache .zcompdump for about a day
if [[ $ZSH_COMPDUMP(#qNmh-20) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -i -d "$ZSH_COMPDUMP"; touch "$ZSH_COMPDUMP"
fi
{
  # compile .zcompdump
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit

export ZSH_TMUX_CONFIG=~/.config/tmux/tmux.conf
export EDITOR=nvim
export DOCKER_DEFAULT_PLATFORM=linux/amd64

bindkey -e

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

NEWLINE=$'\n'
RPROMPT="%?"
PROMPT="%F{cyan}%n@%m %F{yellow}%~ %F{blue}$(current_git_branch_name) ${NEWLINE}%F{green}>%f %"

