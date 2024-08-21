source_file() {
	[ -f "$1" ] && source "$1"
}

source_folder() {
	for file in  $(find "$1/" -mindepth 1 -maxdepth 1)
  	do
		source_file "$file"
	done || return
}

source_folder $HOME/.aliases
