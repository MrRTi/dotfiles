#!/bin/bash

# Setup git
INIT_PWD=pwd

touch ~/.gitconfig

# Global git config
echo Enter default git editor
read GIT_EDITOR
git config --global core.editor $GIT_EDITOR

echo Enter repository folder path
read REPOSITORY_FOLDER
mkdir -p $REPOSITORY_FOLDER
cd $REPOSITORY_FOLDER

echo Git project folders setup. 
while :
do
  echo "Enter projects group name (will be used in config files). Enter empty string to finish"
  read PROJECT_GROUP_NAME
  if [[ $PROJECT_GROUP_NAME == '' ]]; then break; fi
  echo "Enter projects group folder name. Enter empty string to finish"
  read PROJECT_GROUP_FOLDER_NAME
  if [[ $PROJECT_GROUP_FOLDER_NAME == '' ]]; then break; fi
  mkdir $PROJECT_GROUP_FOLDER_NAME

  mkdir -p ~/.config/git
  GIT_CONFIG_FILE_PATH=~/.config/git/${PROJECT_GROUP_NAME}
  rm -f GIT_CONFIG_FILE_PATH
  touch GIT_CONFIG_FILE_PATH
  
  echo "[includeIf \"gitdir:$REPOSITORY_FOLDER/$PROJECT_GROUP_FOLDER_NAME/**\"]" >> ~/.gitconfig
  echo  path=$GIT_CONFIG_FILE_PATH >> ~/.gitconfig
  
  echo Enter git name for this folder
  read GIT_NAME
  echo Enter git email for this folder
  read GIT_EMAIL
  echo [user] >> $GIT_CONFIG_FILE_PATH
  echo  name = $GIT_NAME >> $GIT_CONFIG_FILE_PATH
  echo  email = $GIT_EMAIL >> $GIT_CONFIG_FILE_PATH
done

cd $INIT_PWD || exit
