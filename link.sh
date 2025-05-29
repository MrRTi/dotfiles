#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")

help() {
	echo "This script help you link and unlink configs from this repository"
	echo
	echo "SYNOPSIS:"
	echo
	echo -e "\t./stow.sh <-a|-d|-x>[-s|-y] [-p PACKAGE]"
	echo -e "\t./stow.sh <-h>"
	echo
	echo "OPTIONS:"
	echo -e "\t-a \t Link (re-link) file"
	echo -e "\t-d \t Unlink"
	echo -e "\t-x \t Clean bad links in $HOME/.config catalog"
	echo -e "\t-s \t Do dry-run (no changes applied)"
	echo -e "\t-y \t When -p not used - apply all configs without asking"
	echo -e "\t-p \t Specify package name. If not specified script will run for all configs"
	echo -e "\t-h \t This help"
}

ACTION=""
DRY_RUN=0
AUTO_CONFIRM=0

link-folder() {
	mkdir -p "$HOME/.config"

	find "$SCRIPT_PATH/$1/" -mindepth 1 -type f | while IFS= read -r file; do
		file_full_path=$(echo "$file" | sed -E "s|^\./|$(pwd)/|")
		result_file_path=$(echo "$file" | sed -E "s|^\./[a-zA-Z0-9_]+/?|$HOME/|")
		result_folder=$(dirname "$result_file_path")

		if [ "$DRY_RUN" != 1 ] && [ ! -d "${result_folder}" ]; then
			echo "CREATING FOLDER: ${result_folder}"
			mkdir -pv "${result_folder}"
		fi

		if [ "$ACTION" == "LINK" ] || [ "$ACTION" == "UNLINK" ]; then
			echo "UNLINK: ${result_file_path}"
			if [ "$DRY_RUN" != 1 ] && [ -f "${result_file_path}" ]; then
				unlink "${result_file_path}"
			fi
		fi

		if [ "$ACTION" == "LINK" ]; then
			echo "LINK: ${file_full_path} => ${result_file_path}"
			if [ "$DRY_RUN" != 1 ]; then
				ln -s "${file_full_path}" "${result_file_path}"
			fi
		fi
	done

	if [ "$DRY_RUN" == 1 ]; then
		echo "You selected dry run. Changes not applied"
	fi
}

link-all() {
	configs=$(
		find $SCRIPT_PATH/* -mindepth 0 -maxdepth 0 -type d \( ! -iname ".*" \) |
			sort
	)

	echo "Config list: "
	for config in ${configs[@]}; do
		echo -e "\t - ${config##*/}"
	done

	for config in ${configs[@]}; do
		if [ "$AUTO_CONFIRM" == 1 ]; then
			answer='y'
		else
			echo "$ACTION \"${config##*/}\" config?: y/[n]"
			read answer
		fi
		[ "$answer" = 'y' ] && link-folder ${config##*/}
	done
}

purge-bad-links() {
	echo "Looking for bad links..."
	find ./ -type l ! -exec test -e {} \; -print

	if [ "$DRY_RUN" != 1 ]; then
		find ./ -type l ! -exec test -e {} \; -exec unlink {} \;
	fi
}

while getopts "hadxsyp:" option; do
	case $option in
	h)
		help
		exit
		;;
	a)
		ACTION='LINK'
		;;
	d)
		ACTION='UNLINK'
		;;
	x)
		ACTION='PURGE'
		;;
	s)
		DRY_RUN=1
		;;
	y)
		AUTO_CONFIRM=1
		;;
	p)
		PACKAGE=$OPTARG
		;;
	\?)
		echo "Invalid option"
		exit 1
		;;
	esac
done

if [ "$ACTION" != 'LINK' ] && [ "$ACTION" != 'UNLINK' ] && [ "$ACTION" != 'PURGE' ]; then
	echo "No action selected"
	help
	exit 1
fi

if [ "$ACTION" == 'PURGE' ]; then
	purge-bad-links
	exit
fi

if [ -n "$PACKAGE" ]; then
	link-folder $PACKAGE
else
	link-all
fi
