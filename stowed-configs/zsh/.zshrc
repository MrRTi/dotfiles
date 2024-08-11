#! /bin/zsh

[ -f "$HOME/.config/zsh/zshrc" ] && . "$HOME/.config/zsh/zshrc"

export USER=$(id -un) 
export HOST=$(uname -n)

if [[ "${HOST}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  export HOST="rti-air"
fi


