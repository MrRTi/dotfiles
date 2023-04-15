#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt-get update
	sudo apt-get -y install curl build-essential gcc
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo 'Placeholder for Mac OS'
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew bundle --file ./Brewfile

ln ./.tmux.conf ~/.tmux.conf
ln ./vim-config/.vimrc ~/.vimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# LazyVim
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

./scripts/zsh.sh
git submodule update --init
. ~/.zshrc

./scripts/ssh-keys.sh
./scripts/git.sh
