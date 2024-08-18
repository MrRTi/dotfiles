#!/usr/bin/env zsh

if type fzf >/dev/null 2>&1; then
	source <(fzf --zsh)

	# Open in tmux popup if on tmux, otherwise use --height mode
	export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

	# To follow symbolic links and don't want it to exclude hidden files
	export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
fi
