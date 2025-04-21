#!/usr/bin/env bash

./brew.sh -i
./brew.sh -r

./link.sh -a -y

if [ ! -d "$HOME/.config/nvim" ]; then
	git clone -b lazyvim https://github.com/MrRTi/nvim-config.git $HOME/.config/nvim
fi
