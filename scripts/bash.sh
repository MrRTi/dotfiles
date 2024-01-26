#! bin/bash

[ -f ~/.bashrc ] && rm ~/.bashrc
touch ~/.bashrc
echo "export DOTFILES_PATH=$(pwd)" >> ~/.bashrc
echo ". \${DOTFILES_PATH}/.config/bash/.bashrc" >> ~/.bashrc

