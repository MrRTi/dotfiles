#!/bin/bash

[ ! -f ~/.zshenv ] && touch ~/.zshenv
echo "skip_global_compinit=1" >> ~/.zshenv

[ -f ~/.zshrc ] && rm ~/.zshrc
touch ~/.zshrc
echo "export DOTFILES_PATH=$(pwd)" >> ~/.zshrc
echo ". \${DOTFILES_PATH}/zsh-config/.zshrc" >> ~/.zshrc

echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.zshrc
echo " [ -s \"/usr/local/opt/nvm/nvm.sh\" ] && \. \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm" >> ~/.zshrc
echo " [ -s \"/usr/local/opt/nvm/etc/bash_completion.d/nvm\" ] && \. \"/usr/local/opt/nvm/etc/bash_completion.d/nvm\"  # This loads nvm bash_completion" >> ~/.zshrc

