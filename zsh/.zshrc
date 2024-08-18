source_file() {
	[ -f "$1" ] && source "$1"
}

source_folder() {
	for file in  $(find "$1/" -mindepth 1 -maxdepth 1)
  	do 
		source_file "$file"
	done || return 
}


export EDITOR="nvim"
export VISUAL="nvim"
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export BAT_THEME="ansi"

source_folder $HOME/.aliases
source_folder $HOME/.config/zsh
