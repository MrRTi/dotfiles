#! bin/bash

# NOTE: bash Prompt
COLOR_NC='\e[0m' # No Color
COLOR_BLACK='\e[0;30m'
COLOR_GRAY='\e[1;30m'
COLOR_RED='\e[0;31m'
COLOR_LIGHT_RED='\e[1;31m'
COLOR_GREEN='\e[0;32m'
COLOR_LIGHT_GREEN='\e[1;32m'
COLOR_BROWN='\e[0;33m'
COLOR_YELLOW='\e[1;33m'
COLOR_BLUE='\e[0;34m'
COLOR_LIGHT_BLUE='\e[1;34m'
COLOR_PURPLE='\e[0;35m'
COLOR_LIGHT_PURPLE='\e[1;35m'
COLOR_CYAN='\e[0;36m'
COLOR_LIGHT_CYAN='\e[1;36m'
COLOR_LIGHT_GRAY='\e[0;37m'
COLOR_WHITE='\e[1;37m'

[ -f ~/.git-prompt.sh ] && . ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCONFLICTSTATE="yes"
export GIT_PS1_SHOWCOLORHINTS=1

export PROMPT_COMMAND='__git_ps1 "[\u@\h:\W]" "\\\$ "'
# export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$'
#
# function parse_git_dirty {
#   STATUS="$(git status 2> /dev/null)"
#   if [[ $? -ne 0 ]]; then printf ""; return; else printf "["; fi
#   if echo ${STATUS} | grep -c "renamed:"         &> /dev/null; then printf " >"; else printf ""; fi
#   if echo ${STATUS} | grep -c "branch is ahead:" &> /dev/null; then printf " !"; else printf ""; fi
#   if echo ${STATUS} | grep -c "new file::"       &> /dev/null; then printf " +"; else printf ""; fi
#   if echo ${STATUS} | grep -c "Untracked files:" &> /dev/null; then printf " ?"; else printf ""; fi
#   if echo ${STATUS} | grep -c "modified:"        &> /dev/null; then printf " *"; else printf ""; fi
#   if echo ${STATUS} | grep -c "deleted:"         &> /dev/null; then printf " -"; else printf ""; fi
#   printf " ]"
# }
#
# parse_git_branch() {
   git rev-parse --abbrev-ref HEAD 2> /dev/null
# }
#
# function prepare_prompt() {
#   local PREV_EXIT_CODE=$1
#   local ERR_MESSAGE=""
#   if [[ $PREV_EXIT_CODE != 0 ]]; then
#     ERR_MESSAGE="$COLOR_RED[$PREV_EXIT_CODE]"
#   fi
#
#   local GIT_BRANCH=$(parse_git_branch)
#   local GIT_STATUS=$(parse_git_dirty)
#   echo "$COLOR_CYAN\u@\h $COLOR_YELLOW\w $COLOR_GREEN$GIT_BRANCH $COLOR_RED$GIT_STATUS\n$ERR_MESSAGE$COLOR_LIGHT_GREEN\$$COLOR_NC"
# }

#
# function prompt_command {
#   local RET=$?
#   export PS1=$(prepare_prompt $RET)
# }
