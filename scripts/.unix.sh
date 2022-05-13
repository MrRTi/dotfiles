!/bin/bash

# Install packages
sudo apt-get update
sudo apt-get -y install \
        curl

echo Enter hostname
read INPUTED_HOSTNAME
sudo hostnamectl set-hostname INPUTED_HOSTNAME
