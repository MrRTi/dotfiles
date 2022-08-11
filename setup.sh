#!/bin/bash

sudo apt-get update
sudo apt-get -y install curl build-essential gcc

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew bundle --file ./Brewfile

ln -l ./.tmux.conf ~/.tmux.conf
ln -l ./vim-config/.vimrc ~/.vimrc

scripts/zsh.sh
. ~/.zshrc

scripts/ssh-keys.sh
scripts/git.sh
