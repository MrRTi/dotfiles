# Functions
git_worktree_base(){
	git_dir=$(git rev-parse --show-toplevel 2>/dev/null)

	if [ -z "$git_dir" ] && [ -d ./main/.git ]; then
		# NOTE: to be able to use git command in root project folder
		cd main || return 1
		git_dir=$(git rev-parse --show-toplevel)
	fi

	# NOTE: If we are in folder with .git repo folder
	if [ -d "$git_dir/.git" ]; then
	# NOTE: Return project root like in PROJECT_ROOT/main
	# FIXME: Wil it work with regular repo?
		dirname "$git_dir"
		return 0
	fi

	# NOTE: If we are in worktree
	if [ -f "$git_dir/.git" ]; then
		dirname "$(awk -F': ' '/^gitdir:/ { sub(/\.git\/worktrees\/.*/, "", $2); print $2; exit }' .git)"
		return 0
	fi

	echo "Not git repository"
	return 1
}

git_worktree_select() {
	root=$(git_worktree_base)
	cd "$root/main" || return 1

	git worktree list | \
		awk '{printf "\x1b[34m %s\x1b[0m\t\x1b[33m%s\x1b[0m\n", ($3 == "" ? "(root)" : $3), $1}' |
		sed "s:$root:󰾛 :" |
		sed "/ (root)*/d" |
		column -t |
		fzf --ansi --query "$1" |
		sed "s:󰾛  :$root:" |
		awk '{print $3}'
}

git_worktree_switch(){
	worktree_path=$(git_worktree_select "$1")

	if [ -z "$worktree_path" ]; then
    echo "Worktree path is not set"
		return 1
	fi

	cd "$worktree_path" || return 1
}

git_branch_query() {
  git branch | \
    sed -r "s:\* (.*):\1 [exists]:" | \
    awk '{printf "\x1b[34m%s\x1b[0m\t\x1b[31m%s\x1b[0m\n", $1, $2}' | \
    fzf --print-query --ansi --query "$1" | \
    tail -n 1 | \
    awk '{print $1}'
}

git_worktree_add_query() {
  root=$(git_worktree_base)
	cd "$root/main" || return 1

  branch=$(git_branch_query "$1" | xargs)

  if git branch | grep -q "$branch"; then
    git worktree add "$root/$branch" "$branch"
  else
    git worktree add "$root/$branch" -b "$branch"
  fi

  cd "$root/$branch" || return 1
}

git_worktree_remove() {
  root=$(git_worktree_base)
	cd "$root/main" || return 1

  git worktree list | \
    awk '{print $1}' | \
    fzf --multi | \
    while read -r line; do
      git worktree remove --force "$line"
    done
}

# Aliases
# NOTE: to sort in nvim use `sort /.*=/` on visual selection
alias less='bat -p'
alias lessl='bat -pl'
alias cat='bat -pp'
alias be='bundle exec'
alias b='bundle'
alias c='clear'
alias da='direnv allow'
alias dcrs='docker compose run --rm --use-aliases --service-ports'
alias dcr='docker compose run --rm --use-aliases'
alias dc='docker compose'
alias d='docker'
alias ':q'='exit'
alias eza='eza --git'
alias lt='eza --tree'
alias la='eza -a'
alias ls='eza'
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gc='git commit'
alias glol='git log-pretty'
alias gpf='git push --force origin $(git current-branch)'
alias gpu='git push -u origin $(git current-branch)'
alias grup='git remote update'
alias gres='git reset --hard origin/$(git current-branch)'
alias gs='git status'
alias gw='git worktree'
alias g='git'
alias ll='ls -la'
alias md='mkdir -pv'
alias vf='nvim .'
alias v='nvim'
alias clean_desktop='rm ~/Desktop/*.png'
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'

# Aliases to custom scripts
alias gwa='git_worktree_add_query'
alias gwr='git_worktree_remove'
alias gws='git_worktree_switch'
alias tn='tmux-sessionizer'

# Environment Variables
export PATH="$HOME/.local/bin:$HOME/.orbstack/bin:$HOME/.cargo/bin:$PATH"
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

if [ "$TERM" != "dumb" ] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi


