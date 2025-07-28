#!/usr/bin/env bash

# NOTE: input format "folder1:email1;folder2:email2"

parts=$(echo "$1" | tr ";" "\n")

for line in $parts; do
	folder="$(cut -d ':' -f1 <<<$line)"
	email="$(cut -d ':' -f2 <<<$line)"

	if [[ -z "$folder" || -z "$email" ]]; then
		echo "Error: Missing folder or email" >&2
		exit 1
	fi

	path="$HOME/Developer/$folder"
	gitconfig_path="$path/.gitconfig"

	mkdir -pv "$path"
	touch "$gitconfig_path"

	echo -e "[includeIf \"gitdir:$path/**\"]\n  path = $gitconfig_path" >>"$HOME/.git-includes.gitconfig"
	git config --file $gitconfig_path user.email "$email"
	key=$(ssh-add -L | grep "$email" | head -n 1)
	git config --file $gitconfig_path user.signingkey "$key"

	echo "Set git config values for repos at $path"
	echo -e "\t- email=$email"
	echo -e "\t- signingkey=$key"
done
