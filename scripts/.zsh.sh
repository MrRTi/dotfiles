!/bin/bash

sudo apt update
sudo apt install zsh
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir .zsh_repos
cd .zsh_repos

git clone https://github.com/clarketm/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

chmod 700 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sudo chsh -s $(which zsh)
sudo usermod -s /usr/bin/zsh $(whoami)

cd ..

[ -f ~/.aliases ] && mv ~/.aliases ~/.aliases.backup
cp ../.aliases ~/.aliases


# Copy starship
curl -sS https://starship.rs/install.sh | sh

# Move starship config
[ -f ~/.config/starship.toml ] && mv ~/.config/starship.toml .config/starship.toml.backup
cp ../configs/starship.toml ~/.config/starship.toml

sed -i 's/plugins=.*/plugins=(git k zsh-completions git-flow-avh tmux)/' ${ZDOTDIR:-$HOME}/.zshrc
echo "autoload -U compinit && compinit" >> ${ZDOTDIR:-$HOME}/.zshrc
echo "source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
echo "source ./zsh-autocomplete/zsh-autocomplete.plugin.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
echo "if [ -f .aliases ]; then . ~/.aliases; fi" >> ${ZDOTDIR:-$HOME}/.zshrc
echo "eval \"$(starship init zsh)\"" >> ${ZDOTDIR:-$HOME}/.zshrc
