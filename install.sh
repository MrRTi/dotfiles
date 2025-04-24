#!/usr/bin/env bash

./brew.sh -i

# NOTE: Use brew in next commands
# /opt/homebrew for macOS on Apple Silicon,
# /usr/local for macOS on Intel, and
# /home/linuxbrew/.linuxbrew for Linux.
#
if [ -f "/opt/homebrew/bin/brew" ]; then
	BREW_PATH="/opt/homebrew"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
	BREW_PATH="/home/linuxbrew/.linuxbrew"
else
	BREW_PATH="/use/local"
fi

eval "$($BREW_PATH/bin/brew shellenv)"

./brew.sh -r

mkdir -p "$HOME/.1password"

# NOTE: Link macOS specific paths
if [[ "$(uname)" == "Darwin" ]]; then
	ln -s "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" "$HOME/.1password/agent.sock"
	ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/iCloud"
fi

export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

./link.sh -a -y

DEV_FOLDER="$HOME/Developer/personal"

if [ ! -d "$HOME/.config/nvim" ]; then
	git clone -b lazyvim https://github.com/MrRTi/nvim-config.git "$DEV_FOLDER/nvim-config"
	ln -s "$DEV_FOLDER/nvim-config" "$HOME/.config/nvim"

	cd "$DEV_FOLDER/nvim-config"
	git remote set-url origin git@github.com:MrRTi/nvim-config.git
	cd "$HOME"
fi
