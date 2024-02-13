#!/bin/sh

./.scripts/stow.sh

brew -v || bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ -d "/home/linuxbrew/.linuxbrew/" ]; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#. ~/.bashrc
. ~/.zshrc

rebrew

echo "Setup ssh keys? (Y/N)"
read SETUP_SSH_KEYS_ENABLED 
if [[ $SETUP_SSH_KEYS_ENABLED == 'Y' ]]; then
  ./.scripts/ssh-keys.sh
else 
  echo 'Skipping ssh setup'
fi


echo "Setup git config? (Y/N)"
read SETUP_GIT_CONFIG_ENABLED 
if [[ $SETUP_GIT_CONFIG_ENABLED == 'Y' ]]; then
  ./.scripts/git.sh
else 
  echo 'Skipping git config setup'
fi

