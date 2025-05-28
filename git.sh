#!/usr/bin/env bash

# NOTE: input format "folder1:email1;folder2:email2"
#
parts=$(echo "$1" | tr ";" "\n")

for line in $parts; do
	folder="$(cut -d ':' -f1 <<<$line)"
	email="$(cut -d ':' -f2 <<<$line)"

	path="$HOME/dev/$folder"
	gitconfig_path="$path/.gitconfig"

	mkdir -pv "$path"
	touch "$gitconfig_path"

	echo -e "[includeIf \"gitdir:$path/**\"]\n  path = $gitconfig_path" >>"$HOME/.config/git/if-config"
	git config --file $gitconfig_path user.email "$email"
	key=$(ssh-add -L | grep "$email" | head -n 1)
	git config --file $gitconfig_path user.signingkey "$key"

	echo "Set git config values for repos at $path"
	echo -e "\t- email=$email"
	echo -e "\t- signingkey=$key"
done
