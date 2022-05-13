#!/bin/bash

# Create ssh_keys
ssh-keygen -t ed25519 -C 'gitlab-remote' -P '' -f ~/.ssh/gitlab
ssh-keygen -t ed25519 -C 'github-remote' -P '' -f ~/.ssh/github

mv ~/.ssh/config ~/.ssh/config.backup
cp ./configs/.ssh_config ~/.ssh/config
