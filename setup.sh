#!/bin/bash

sudo apt-get update
sudo apt-get -y install curl

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file ./Brewfile

ln -l ./.tmux.conf ~/.tmux.conf
ln -l ./vim-config/.vimrc ~/.vimrc

scripts/zsh.sh
. ~/.zshrc

scripts/ssh-keys.sh
scripts/git.sh

