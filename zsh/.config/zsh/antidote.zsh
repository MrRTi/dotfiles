#!/usr/bin/env zsh

source_antidote () {
  if [ command -v brew >/dev/null 2>&1 ] && [ -f $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh ]; then
    source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
  elif [ -f ${ZDOTDIR:-~}/.antidote/antidote.zsh ]; then 
    source ${ZDOTDIR:-~}/.antidote/antidote.zsh
  else
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
    source ${ZDOTDIR:-~}/.antidote/antidote.zsh
  fi
}

source_antidote

antidote load

zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins.zsh
[[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt
fpath+=(${ZDOTDIR:-~}/.antidote)
autoload -Uz $fpath[-1]/antidote
if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
  (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
fi
source $zsh_plugins
