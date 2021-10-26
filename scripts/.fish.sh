sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish

sh -c "$(curl -fsSL https://starship.rs/install.sh)"

mkdir ~/.config/fish
echo 'starship init fish | source' >> ~/.config/fish/config.fish
mv ~/.aliases ~/.aliases.backup
cp .aliases ~/.aliases
echo 'source ~/.aliases' >> ~/.config/fish/config.fish
sudo chsh -s $(which fish)

mv ~/.config/starship.toml .config/starship.toml.backup
cp ../configs/starship.toml ~/.config/starship.toml
