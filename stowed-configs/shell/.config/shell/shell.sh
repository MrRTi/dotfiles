#! /bin/sh

add_file() {
  [ -f "$1" ] && . "$1"
}

add_all() {
  for file in "$@"; do add_file "$file"; done || return 
}

add_all "$HOME"/.config/shell/extensions/*.sh

# NOTE: Exports
export LANG='C.UTF-8'
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export EDITOR=nvim
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# NOTE: Add gems executables to path
gembin=$(gem env | sed -n "s/.*EXECUTABLE DIRECTORY: \(.*\)/\1/p")
export PATH="$gembin":"$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin":"$PATH"

add_file "/opt/homebrew/etc/profile.d/autojump.sh"
