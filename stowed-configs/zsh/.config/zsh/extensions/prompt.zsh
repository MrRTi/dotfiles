#!/usr/bin/env zsh

source_gitstatus () {
  if [ command -v brew >/dev/null 2>&1 ] && [ -f $(brew --prefix)/opt/gitstatus/gitstatus.plugin.zsh ]; then
    source $(brew --prefix)/opt/gitstatus/gitstatus.plugin.zsh
  elif [ -f ~/gitstatus/gitstatus.plugin.zsh ]; then 
    source ~/gitstatus/gitstatus.plugin.zsh 
  else
    git clone --depth=1 https://github.com/romkatv/gitstatus.git ${HOME}/gitstatus
    source ~/gitstatus/gitstatus.plugin.zsh 
  fi
}

source_gitstatus

NEWLINE=$'\n'
GIT_PROMPT_COUNTERS=${GIT_PROMPT_COUNTERS:=false}
GIT_PROMPT_LESS_DIRTY=${GIT_PROMPT_LESS_DIRTY:=true}

function render_counter() {
  $GIT_PROMPT_COUNTERS && printf "$1 "
}

function my_set_prompt() {
  type gitstatus_query &>/dev/null || source_git_status

  #RPROMPT="%?"
  PROMPT=""

  # NOTE: User & host name
  if [ -z $TMUX ]; then
    USER_HOST_PART="%F{cyan}%n@%m " 
  else
    USER_HOST_PART="%F{cyan}  "
  fi
  
  PROMPT+="$USER_HOST_PART"

  FOLDER_PART="%F{yellow}%(5~|%-1~/…/%2~|%3~)"
  PROMPT+="$FOLDER_PART"

  IS_GIT_FOLDER=$(git rev-parse --is-inside-repository &>/dev/null && echo "true" || echo "false")

  GIT_PART=""
  BRANCH_PART=""
  GIT_DIRTY_PART=""

  if [ "$IS_GIT_FOLDER" = "true" ]; then
    GIT_PART+="  "

    IS_BARE_REPO=$(git rev-parse --is-bare-repository 2>/dev/null)
    BARE_ROOT=$(git worktree list | grep 'bare' | awk '{print $1}')
    if  [ "$IS_BARE_REPO" = "true" ]; then
      [ "$(pwd)" = "$BARE_ROOT" ] && GIT_PART+="󰋜 " || GIT_PART+="󰾛 "
    fi

    if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
      BRANCH="${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}"  # escape % 

      if [ ${BRANCH##*/} = ${${PWD%/}##*/} ]; then
        BRANCH_PART="󰐅 "
      else
        BRANCH_PART=" $BRANCH"
      fi

      local      clean='%76F'   # green foreground
      local   modified='%178F'  # blue foreground
      local  untracked='%39F'   # blue foreground
      local conflicted='%196F'  # red foreground
      local        red='%196F'  # red foreground

      # ⇣42 if behind the remote.
      (( VCS_STATUS_COMMITS_BEHIND )) && GIT_DIRTY_PART+="${clean}⇣$(render_counter ${VCS_STATUS_COMMITS_BEHIND})"
      # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
      (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && GIT_DIRTY_PART+=""
      (( VCS_STATUS_COMMITS_AHEAD  )) && GIT_DIRTY_PART+="${clean}⇡$(render_counter ${VCS_STATUS_COMMITS_AHEAD})"
      # ⇠42 if behind the push remote.
      (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_DIRTY_PART+="${clean}⇠$(render_counter ${VCS_STATUS_PUSH_COMMITS_BEHIND})"
      (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_DIRTY_PART+=""
      # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
      (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && GIT_DIRTY_PART+="${clean}⇢$(render_counter ${VCS_STATUS_PUSH_COMMITS_AHEAD})"

      # 'merge' if the repo is in an unusual state.
      [[ -n $VCS_STATUS_ACTION     ]] && GIT_DIRTY_PART+="${conflicted}${VCS_STATUS_ACTION}"
      # ~42 if have merge conflicts.
      (( VCS_STATUS_NUM_CONFLICTED )) && GIT_DIRTY_PART+="${conflicted}~$(render_counter ${VCS_STATUS_NUM_CONFLICTED})"

      if [ $GIT_DIRTY_PART_LESS_DIRTY ]; then
        (( VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED )) && GIT_DIRTY_PART+="$red!"
      else
        # +42 if have staged changes.
        (( VCS_STATUS_NUM_STAGED     )) && GIT_DIRTY_PART+="${modified}+$(render_counter ${VCS_STATUS_NUM_STAGED})"
        # !42 if have unstaged changes.
        (( VCS_STATUS_NUM_UNSTAGED   )) && GIT_DIRTY_PART+="${modified}!$(render_counter ${VCS_STATUS_NUM_UNSTAGED})"
        # ?42 if have untracked files. It's really a question mark, your font isn't broken.
        (( VCS_STATUS_NUM_UNTRACKED  )) && GIT_DIRTY_PART+="${untracked}?$(render_counter ${VCS_STATUS_NUM_UNTRACKED})"
      fi

      # *42 if have stashes.
      (( VCS_STATUS_STASHES        )) && GIT_DIRTY_PART+="${clean}*$(render_counter ${VCS_STATUS_STASHES})"
    fi

    GIT_PART+=$BRANCH_PART
    GIT_DIRTY_PART=$(echo $GIT_DIRTY_PART | xargs)
    [ -n "$GIT_DIRTY_PART" ] && GIT_PART+="%F{blue}[$GIT_DIRTY_PART%F{blue}]"
  fi

  PROMPT+="%F{blue}$GIT_PART"
  PROMPT+=" %F{red}%(?..%B(%?%)%b)%F{green}>%f %"
  setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}

gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
autoload -Uz add-zsh-hook
add-zsh-hook precmd my_set_prompt

