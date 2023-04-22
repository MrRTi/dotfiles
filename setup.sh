#!/bin/bash

mkdir -p ~/.config

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

mv ~/.config/tmux ~/.config/tmux.bak
ln -sf $(pwd)/.config/tmux ~/.config/tmux

mv ~/.vimrc ~/.vimrc.bak
ln -sf $(pwd)/vim-config/.vimrc ~/.vimrc

mv ~/.config/alacritty ~/.config/alacritty.bak
ln -sf $(pwd)/.config/alacritty/ ~/.config/alacritty

mv ~/.config/lsd ~/.config/lsd.bak
ln -sf $(pwd)/.config/lsd ~/.config/lsd


git clone https://github.com/MrRTi/astronvim-config.git ~/astronvim-config
mv ~/.config/astronvim ~/.config/astronvim.bak
mkdir -p ~/.config/astronvim/lua/user
ln -sf ~/astronvim-config ~/.config/astronvim/lua/user

mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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


