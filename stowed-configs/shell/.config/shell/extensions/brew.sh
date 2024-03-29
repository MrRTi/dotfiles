#! /bin/sh
# NOTE: multi arch aliases for apple silicon
alias brew="arch -arm64e /opt/homebrew/bin/brew" # arm64e homebrew path (m1)
alias ibrew="arch -x86_64 /usr/local/bin/brew"    # x86_64 homebrew path (intel)

function rebrew() {
  brew bundle --file ${1:-~/dotfiles/Brewfile} 
}

function brewdump() {
  brew bundle dump --force --file=${1:-~/dotfiles/Brewfile}
}


