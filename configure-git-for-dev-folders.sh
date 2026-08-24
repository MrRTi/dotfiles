#!/usr/bin/env bash

# NOTE: input format "folder1:email1;folder2:email2"

parts=$(echo "$1" | tr ";" "\n")

for line in $parts; do
	folder="$(cut -d ':' -f1 <<<"$line")"
	email="$(cut -d ':' -f2 <<<"$line")"

	if [[ -z "$folder" || -z "$email" ]]; then
		echo "Error: Missing folder or email" >&2
		exit 1
	fi

	path="$HOME/Developer/$folder"
	gitconfig_path="$path/.gitconfig"
	include_folder="$HOME/.config/git/"

	mkdir -pv "$path"
	touch "$gitconfig_path"

	mkdir -pv "$include_folder"
	touch "$include_folder/includes.gitconfig"

	if ! grep -qF "gitdir:$path/**" "$include_folder/includes.gitconfig"; then
		echo -e "[includeIf \"gitdir:$path/**\"]\n  path = \"$gitconfig_path\"" >>"$include_folder/includes.gitconfig"
	fi
	git config --file "$gitconfig_path" user.email "$email"
	key=$(ssh-add -L | grep "$email" | head -n 1)
	if [ -z "$key" ]; then
		echo "Warning: No SSH key found for $email, skipping signing key setup" >&2
	else
		git config --file "$gitconfig_path" user.signingkey "$key"
	fi

	echo "Set git config values for repos at $path"
	echo -e "\t- email=$email"
	echo -e "\t- signingkey=$key"
done
