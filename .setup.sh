#!/bin/bash

# Move configs
rm -f .tmux.conf
cp ~/.usr_config/.tmux.conf .tmux.conf 

# Install packages
dnf install zsh curl

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

.zshrc-updates.sh

# Create ssh_keys
ssh-keygen -t ed25519 -C 'gitlab-remote' -P '' -f ~/.ssh/gitlab
ssh-keygen -t ed25519 -C 'github-remote' -P '' -f ~/.ssh/github
rm -f ~/.ssh/config
cp ~/.usr_config/.ssh_config ~/.ssh/config

# Setup git
rm -f ~/.gitconfig
cp ~/.usr_config/.gitconfig ~/.gitconfig

# Personal git
echo Enter name for personal git projects
read git-personal-name
echo Enter email for personal git projects
read git-personal-email
rm -f ~/.gitconfig-personal
touch ~/.gitconfig-personal
echo [user] >> ~/.gitconfig-personal
echo name = $git-personal-name >> ~/.gitconfig-personal
echo email = $git-personal-email >> ~/.gitconfig-personal

# Work git
echo Enter name for work git projects
read git-work-name
echo Enter email for work git projects
read git-work-email
rm -f ~/.gitconfig-work
touch ~/.gitconfig-work
echo [user] >> ~/.gitconfig-work
echo name = $git-work-name >> ~/.gitconfig-work
echo email = $git-work-email >> ~/.gitconfig-work

# Global git config
git config -g editor=vim

