#! /bin/sh

[ -n "${DOTFILES_PATH}" ] || export DOTFILES_PATH=~/.dotfiles

# NOTE: Source all functions
# shellcheck source=/dev/null
for f in "$DOTFILES_PATH"/.config/shell/extensions/*.sh; do . "$f"; done

# NOTE: Exports
export LANG='C.UTF-8'
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export EDITOR=nvim

# NOTE: Add gems executables to path
gembin=$(gem env | sed -n "s/.*EXECUTABLE DIRECTORY: \(.*\)/\1/p")
export PATH="$gembin":"$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

add_file "/opt/homebrew/etc/profile.d/autojump.sh"
