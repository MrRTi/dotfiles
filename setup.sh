#!/bin/bash

mkdir -p ~/.config
mkdir -p ~/.config/tmux
mkdir -p ~/.config/astronvim/lua
mkdir -p ~/.config/alacritty

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get update
	sudo apt-get -y install curl build-essential gcc
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo 'Placeholder for Mac OS'
fi

brew -v || bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ -d "/home/linuxbrew/.linuxbrew/" ]; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew bundle --file ./Brewfile

./scripts/back-up-configs.sh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
git clone https://github.com/MrRTi/astronvim-config.git ~/astronvim-config
git clone https://github.com/catppuccin/alacritty.git ~/.config/alacritty/catppuccin

./scripts/link-files.sh

./scripts/zsh.sh
. ~/.zshrc


echo Setup ssh keys? (Y/N)
read SETUP_SSH_KEYS_ENABLED 
if [[ $SETUP_SSH_KEYS_ENABLED == 'Y' ]]; then
  ./scripts/ssh-keys.sh
else 
  echo 'Skipping ssh setup'
fi


echo Setup git config? (Y/N)
read SETUP_GIT_CONFIG_ENABLED 
if [[ $SETUP_GIT_CONFIG_ENABLED == 'Y' ]]; then
	./scripts/git.sh
else 
  echo 'Skipping git config setup'
fi


