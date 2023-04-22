#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get update
	sudo apt-get -y install curl build-essential gcc
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo 'Placeholder for Mac OS'
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ -d "/home/linuxbrew/.linuxbrew/" ]; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew bundle --file ./Brewfile

ln -sf ./.tmux.conf ~/.tmux.conf
ln -sf ./vim-config/.vimrc ~/.vimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# AstroNvim
# https://astronvim.com/#%EF%B8%8F-installation
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
rm -rf ~/.config/nvim/.git

./scripts/zsh.sh
git submodule update --init
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


