#!/bin/bash

[ ! -f ~/.zshenv ] && touch ~/.zshenv
echo "skip_global_compinit=1" >> ~/.zshenv

[ -f ~/.zshrc ] && rm ~/.zshrc
touch ~/.zshrc
echo "export DOTFILES_PATH=$(pwd)" >> ~/.zshrc
echo ". \${DOTFILES_PATH}/zsh-config/.zshrc" >> ~/.zshrc
