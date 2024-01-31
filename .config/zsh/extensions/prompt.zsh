#! /bin/zsh

if [[ -f $(brew --prefix)/opt/gitstatus/gitstatus.plugin.zsh ]]; then
  source $(brew --prefix)/opt/gitstatus/gitstatus.plugin.zsh
fi
if [[ -f ~/gitstatus/gitstatus.plugin.zsh ]]; then 
  source ~/gitstatus/gitstatus.plugin.zsh 
fi


NEWLINE=$'\n'
GIT_PROMPT_COUNTERS=${GIT_PROMPT_COUNTERS:=false}
GIT_PROMPT_LESS_DIRTY=${GIT_PROMPT_LESS_DIRTY:=true}

function render_counter() {
  $GIT_PROMPT_COUNTERS && printf "$1 "
}

function my_set_prompt() {
  #RPROMPT="%?"
  PROMPT=""
  [ -z $TMUX ] && PROMPT+="%F{cyan}%n@%m " 
  PROMPT+="%F{yellow}%(5~|%-1~/…/%2~|%3~)"

  if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
    BRANCH="${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}"  # escape % 
    if [ ${BRANCH##*/} = ${PWD##*/} ]; then
      PROMPT_BRANCH=" 󰐅"
    else
      PROMPT_BRANCH=" $BRANCH"
    fi

    PROMPT+="%F{blue}$PROMPT_BRANCH"
    local      clean='%76F'   # green foreground
    local   modified='%178F'  # blue foreground
    local  untracked='%39F'   # blue foreground
    local conflicted='%196F'  # red foreground
    local        red='%196F'  # red foreground

    GIT_PROMPT=""
    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && GIT_PROMPT+="${clean}⇣$(render_counter ${VCS_STATUS_COMMITS_BEHIND})"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && GIT_PROMPT+=""
    (( VCS_STATUS_COMMITS_AHEAD  )) && GIT_PROMPT+="${clean}⇡$(render_counter ${VCS_STATUS_COMMITS_AHEAD})"
    # ⇠42 if behind the push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_PROMPT+="${clean}⇠$(render_counter ${VCS_STATUS_PUSH_COMMITS_BEHIND})"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_PROMPT+=""
    # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && GIT_PROMPT+="${clean}⇢$(render_counter ${VCS_STATUS_PUSH_COMMITS_AHEAD})"
    
    # 'merge' if the repo is in an unusual state.
    [[ -n $VCS_STATUS_ACTION     ]] && GIT_PROMPT+="${conflicted}${VCS_STATUS_ACTION}"
    # ~42 if have merge conflicts.
    (( VCS_STATUS_NUM_CONFLICTED )) && GIT_PROMPT+="${conflicted}~$(render_counter ${VCS_STATUS_NUM_CONFLICTED})"
      
    if [ $GIT_PROMPT_LESS_DIRTY ]; then
      (( VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED )) && GIT_PROMPT+="$red!"
    else
      # +42 if have staged changes.
      (( VCS_STATUS_NUM_STAGED     )) && GIT_PROMPT+="${modified}+$(render_counter ${VCS_STATUS_NUM_STAGED})"
      # !42 if have unstaged changes.
      (( VCS_STATUS_NUM_UNSTAGED   )) && GIT_PROMPT+="${modified}!$(render_counter ${VCS_STATUS_NUM_UNSTAGED})"
      # ?42 if have untracked files. It's really a question mark, your font isn't broken.
      (( VCS_STATUS_NUM_UNTRACKED  )) && GIT_PROMPT+="${untracked}?$(render_counter ${VCS_STATUS_NUM_UNTRACKED})"
    fi

    # *42 if have stashes.
    (( VCS_STATUS_STASHES        )) && GIT_PROMPT+="${clean}*$(render_counter ${VCS_STATUS_STASHES})"

    GIT_PROMPT=$(echo $GIT_PROMPT | xargs)
    [ -n "$GIT_PROMPT" ] && PROMPT+="%F{blue}[$GIT_PROMPT%F{blue}]"
  else
    git rev-parse --is-bare-repository 2>/dev/null && PROMPT+=" %F{blue}󰐅:BARE"
  fi

  PROMPT+=" %F{red}%(?..%B(%?%)%b)%F{green}>%f %"
  setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}

gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
autoload -Uz add-zsh-hook
add-zsh-hook precmd my_set_prompt

