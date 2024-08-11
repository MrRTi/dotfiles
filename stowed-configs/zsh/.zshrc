#! /bin/zsh

[ -f "$HOME/.config/zsh/zshrc" ] && . "$HOME/.config/zsh/zshrc"

export USER=$(id -un) 
export HOST=$(uname -n)

if [[ "${HOST}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  export HOST="rti-air"
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
