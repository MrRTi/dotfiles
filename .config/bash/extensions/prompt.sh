#! /bin/bash

# NOTE: bash Prompt
COLOR_NC='\e[0m' # No Color
# COLOR_BLACK='\e[0;30m'
# COLOR_GRAY='\e[1;30m'
# COLOR_RED='\e[0;31m'
# COLOR_LIGHT_RED='\e[1;31m'
# COLOR_GREEN='\e[0;32m'
# COLOR_LIGHT_GREEN='\e[1;32m'
# COLOR_BROWN='\e[0;33m'
COLOR_YELLOW='\e[1;33m'
# COLOR_BLUE='\e[0;34m'
# COLOR_LIGHT_BLUE='\e[1;34m'
# COLOR_PURPLE='\e[0;35m'
# COLOR_LIGHT_PURPLE='\e[1;35m'
COLOR_CYAN='\e[0;36m'
# COLOR_LIGHT_CYAN='\e[1;36m'
# COLOR_LIGHT_GRAY='\e[0;37m'
# COLOR_WHITE='\e[1;37m'

[ -f ~/.git-prompt.sh ] || curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
# shellcheck source=/dev/null
[ -f ~/.git-prompt.sh ] && . "$HOME/.git-prompt.sh"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCONFLICTSTATE="yes"
export GIT_PS1_SHOWCOLORHINTS=1

USER_HOST="\[$COLOR_CYAN\]\u@\h:"
[ -n "$TMUX" ] && USER_HOST=""
export PROMPT_COMMAND='__git_ps1 "[$USER_HOST\[$COLOR_YELLOW\]\W\[$COLOR_NC\]]" "\\\$ "'
