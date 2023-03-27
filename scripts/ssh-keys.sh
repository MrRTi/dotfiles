#!/bin/bash

# Create ssh_keys
[[ ! -f ~/.ssh/gitlab ]] ssh-keygen -t ed25519 -C 'gitlab-remote' -P '' -f ~/.ssh/gitlab
[[ ! -f ~/.ssh/github ]] ssh-keygen -t ed25519 -C 'github-remote' -P '' -f ~/.ssh/github

[[ ! -f ~/.ssh/config ]] && touch ~/.ssh/config
echo "" >> ~/.ssh/config
cat ./.ssh/config >> ~/.ssh/config
