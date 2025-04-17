#! /bin/bash

./brew.sh -i
./brew.sh -r

./link.sh -a -y

git clone -b lazyvim https://github.com/MrRTi/nvim-config.git $HOME/.config/nvim
