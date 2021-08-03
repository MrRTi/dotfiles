!/bin/bash

sudo apt install -y git && git clone https://github.com/MrRTi/.usr_config.git && .usr_config/.setup.sh

# Move configs
rm -f .tmux.conf
cp ~/.usr_config/.tmux.conf .tmux.conf 

# Install packages
sudo apt-get update
sudo apt-get -y install \
	zsh \
	curl \
	apt-transport-https \
	ca-certificates \
	gnupg \
	lsb-release \
	git \
	tmux \
	git-flow

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/xUbuntu_19.10/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-completions.list
curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/xUbuntu_19.10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-completions.gpg > /dev/null
sudo apt update
sudo apt install zsh-completions

# Install zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Instal zsh autocomlete
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
source ~/Git/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Installs plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Fix permissions
chmod 700 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Create ssh_keys
ssh-keygen -t ed25519 -C 'gitlab-remote' -P '' -f ~/.ssh/gitlab
ssh-keygen -t ed25519 -C 'github-remote' -P '' -f ~/.ssh/github
rm -f ~/.ssh/config
cp ~/.usr_config/.ssh_config ~/.ssh/config

sudo chsh -s $(which zsh)
sudo usermod -s /usr/bin/zsh $(whoami)

~/.usr_config/.zshrc-updates.sh

sudo hostnamectl set-hostname remote

# Setup git
rm -f ~/.gitconfig
cp ~/.usr_config/.gitconfig ~/.gitconfig

mkdir -p ~/repo/work
mkdir -p ~/repo/personal

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
git config --global core.editor "vim"

echo Setup p10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

