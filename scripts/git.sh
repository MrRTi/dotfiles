#!/bin/bash

# Setup git
INIT_PWD = pwd

echo Enter repository folder path
read REPOSITORY_FOLDER
mkdir -p $REPOSITORY_FOLDER
cd $REPOSITORY_FOLDER

echo Enter personal projects folder name
read PERSONAL_PROJECTS_FOLDER_NAME
mkdir $PERSONAL_PROJECTS_FOLDER_NAME

echo Enter work projects folder name
read WORK_PROJECTS_FOLDER_NAME
mkdir $WORK_PROJECTS_FOLDER_NAME

cd $INIT_PWD

# Set gitconfig
touch ~/.gitconfig
echo "[includeIf \"gitdir:$REPOSITORY_FOLDER/$PERSONAL_PROJECTS_FOLDER_NAME/**\"]" >> ~/.gitconfig
echo  path=.gitconfig-personal >> ~/.gitconfig
echo "[includeIf \"gitdir:$REPOSITORY_FOLDER/$WORK_PROJECTS_FOLDER_NAME/**\"]" >> ~/.gitconfig
echo  path=.gitconfig-work >> ~/.gitconfig

# Personal git
echo Enter name for personal git projects
read GIT_PESONAL_NAME
echo Enter email for personal git projects
read GIT_PESONAL_EMAIL
rm -f ~/.gitconfig-personal
touch ~/.gitconfig-personal
echo [user] >> ~/.gitconfig-personal
echo name = $GIT_PESONAL_NAME >> ~/.gitconfig-personal
echo email = $GIT_PESONAL_EMAIL >> ~/.gitconfig-personal

# Work git
echo Enter name for work git projects
read GIT_WORK_NAME
echo Enter email for work git projects
read GIT_WORK_EMAIL
rm -f ~/.gitconfig-work
touch ~/.gitconfig-work
echo [user] >> ~/.gitconfig-work
echo name = $GIT_WORK_NAME >> ~/.gitconfig-work
echo email = $GIT_WORK_EMAIL >> ~/.gitconfig-work

# Global git config
echo Enter default git editor
read GIT_EDITOR
git config --global core.editor $GIT_EDITOR
