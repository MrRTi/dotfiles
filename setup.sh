#!/bin/bash

sudo apt-get update
sudo apt-get -y install curl build-essential gcc

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew bundle --file ./Brewfile

ln ./.tmux.conf ~/.tmux.conf
ln ./vim-config/.vimrc ~/.vimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

./scripts/zsh.sh
git submodule update --init
. ~/.zshrc

./scripts/ssh-keys.sh
./scripts/git.sh
