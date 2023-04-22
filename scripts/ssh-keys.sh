#!/bin/bash

touch ~/.ssh/config

# Create ssh_keys:
while :
do
  echo "Enter ssh key filename to generate (ed25519). Enter empty string to finish"
  read SSH_KEY_NAME
  if [[ $SSH_KEY_NAME == '' ]]; then break; fi
  
  ssh-keygen -t ed25519 -C ${SSH_KEY_NAME} -f ~/.ssh/${SSH_KEY_NAME}

  echo "Enter host name for this key to use in ssh config"
  read HOST_NAME
  echo "Host ${HOST_NAME}" >> ~/.ssh/config
  echo "  AddKeysToAgent yes" >> ~/.ssh/config
  echo "  IdentityFile ~/.ssh/${SSH_KEY_NAME}" >> ~/.ssh/config
  echo "" >> ~/.ssh/config
done

