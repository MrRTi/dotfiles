#! /bin/bash

help() {
  echo "This script help save and apply brew packages list"
  echo
  echo "SYNOPSIS:"
  echo
  echo -e "\t./brew.sh <-h|-i|-d|-r>"
  echo
  echo "OPTIONS:"
  echo -e "\t-h \t Help"
  echo -e "\t-i \t Install brew"
  echo -e "\t-d \t Save packages list to Brewfile"
  echo -e "\t-r \t Install all packages from Brewfile"
}

install-brew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

brew-dump() {
  echo "Saving packages list to Brewfile"
  brew bundle dump --force --file=./Brewfile
  echo "Brew bundle saved to Brewfile"
  echo "For info on \"mas\" - see https://github.com/mas-cli/mas"
}

rebrew() {
  echo "Installing packages from Brewfile"
  brew bundle install --file=./Brewfile
}

while getopts "hidr" option; do
  case $option in
    h)
      help
      exit
      ;;
    i)
      install-brew
      exit
      ;;
    d)
      brew-dump
      exit
      ;;
    r)
      rebrew
      exit
      ;;
    \?)
      echo "Invalid option"
      exit 1;;
  esac
done

if [ ${#STOW_ARGS[@]} = 0 ]; then
  echo "No options provided"
  echo
  help
  exit 1
fi

