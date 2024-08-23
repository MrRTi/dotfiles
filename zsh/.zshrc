# ==== PROFILING ====

ZSH_PROFILING=0
if [ $ZSH_PROFILING -eq 1 ];then zmodload zsh/zprof; fi

# ==== ALIASES ====

# ---- shell aliases  ----

alias ..='cd ..'
alias md='mkdir -pv'
alias ll='ls -la'
alias c='clear'
alias :q='exit'

alias clean_desktop="rm ~/Desktop/*.png"


# ---- zsh aliases  ----

alias rel-env="source $HOME/.zshenv"
alias rel-shell="source $HOME/.zshrc"
alias rel-shell-debug="ZSH_PROFILING=1 rel-shell"
alias zshr="rel-env && rel-shell"


# ---- bat aliases  ----

if type bat > /dev/null 2>&1; then
  alias cat='bat -pp'
  alias less='bat -p'
  alias lessl='bat -pl'
fi


# ---- docker aliases  ----

if type docker >/dev/null 2>&1; then
  alias d='docker'
  alias dc='docker compose'
  alias dcr='dc run --rm --use-aliases'
  alias dcrs='dcr --service-ports'
fi

# ---- eza aliases  ----

if type eza >/dev/null 2>&1; then
  alias ls='eza'
fi


# ---- git aliases  ----

if type git >/dev/null 2>&1; then
  alias g='git'

  alias ga='g add'
  alias gb='g branch'
  alias gc='g commit'
  alias gcb='g rev-parse --abbrev-ref HEAD'
  alias gco='g checkout'
  alias gd='g diff'
  alias glol='g log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
  alias gpu="g push -u origin \$(gcb)"
  alias grup='g remote update'
  alias gs='g status '

  alias gw='g worktree'
  alias gwa='gw add'
  alias gwl='gw list'
  alias gwp='gw prune'
  alias gwr='gw remove'
  alias gwrf='gw remove --force'
fi


# ---- nvim aliases  ----

if type nvim >/dev/null 2>&1; then
  alias vim=nvim
  alias v=vim
  alias vf='vim .'
fi


# ---- tldr aliases  ----

if type tldr > /dev/null 2>&1 && type fzf > /dev/null 2>&1; then
  alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
fi


# ---- tmux aliases  ----

if type tmux_sessionizer >/dev/null 2>&1; then
  alias tn='tmux_sessionizer'
fi


# ==== LIB'S RELATED CONFIG ====

# ---- bat ----

if type bat > /dev/null 2>&1; then
  export BAT_THEME="ansi"
fi

# ---- fzf ----

if type fzf >/dev/null 2>&1; then
  source <(fzf --zsh)

  # Open in tmux popup if on tmux, otherwise use --height mode
  export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

  # To follow symbolic links and don't want it to exclude hidden files
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
fi


# ---- git ----

if type git > /dev/null 2>&1 && type fzf > /dev/null 2>&1; then
  __git-worktree-root() {
    git worktree list | grep 'bare' | awk '{print $1}'
  }

  __git_branch_query() {
    git branch | fzf --print-query | head -n 1
  }

  __git-worktree-add-query() {
    BRANCH=$(__git_branch_query)
    echo "Creating worktree at ${BRANCH}"
    git worktree add -b "${BRANCH}" "$(__git-worktree-root)/${BRANCH}"
  }

  alias gwa="__git-worktree-add-query"

  __git-worktree-select() {
    git worktree list | fzf | awk '{print $1}'
  }

  __git-worktree-delete-query() {
    __git-worktree-select | xargs -0 git worktree remove
  }

  alias gwdq="__git-worktree-delete-query"

  __git-worktree-delete-force-query() {
    __git-worktree-select | xargs -0 git worktree remove --force
  }

  alias gwdqf="__git-worktree-delete-force-query"

  __git-worktree-select() {
    NEW_PATH=$(git worktree list | awk '{print ($3 == "" ? "(root)" : $3), $1}' | fzf | awk '{print $2}')
    cd "$NEW_PATH" || exit
  }

  alias gws="__git-worktree-select"
fi


# ---- k9s ----

if type k9s >/dev/null 2>&1; then
  export K9S_CONFIG_DIR="$HOME/.config/k9s"
fi


# ---- nvim ----

if type nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
  export VISUAL="nvim"
fi


# ==== ZSH CONFIG ====

# ---- vi-mode ----

# Enable vi mode
bindkey -v
export KEYTIMEOUT=1

# Update cursor when in insert mode
__render_block() {
  echo -ne '\e[2 q'
}

__render_beam() {
  echo -ne '\e[6 q'
}

__zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    __render_block
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    __render_beam
  fi
}

__zle-line-init() {
  __render_beam
}

zle -N __zle-keymap-select
zle -N __zle-line-init

# edit command in visual mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# add text objects to use something like `da"`
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed

for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# Add surround to normal mode
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround


# ---- prompt ----

__source_gitstatus() {
  if [ command -v brew >/dev/null 2>&1 ] && [ -f $(brew --prefix)/opt/gitstatus/gitstatus.plugin ]; then
    source $(brew --prefix)/opt/gitstatus/gitstatus.plugin
  elif [ -d "$HOME"/gitstatus/ ]; then
    source ~/gitstatus/gitstatus.plugin.zsh
  else
    git clone --depth=1 https://github.com/romkatv/gitstatus.git ${HOME}/gitstatus
    source ~/gitstatus/gitstatus.plugin.zsh
  fi
}

__source_gitstatus

NEWLINE=$'\n'
GIT_PROMPT_COUNTERS=${GIT_PROMPT_COUNTERS:=false}
GIT_PROMPT_LESS_DIRTY=${GIT_PROMPT_LESS_DIRTY:=true}

__render_counter() {
  $GIT_PROMPT_COUNTERS && printf "$1 "
}

__my_set_prompt() {
  type gitstatus_query &>/dev/null || source_git_status

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
      (( VCS_STATUS_COMMITS_BEHIND )) && GIT_DIRTY_PART+="${clean}⇣$(__render_counter ${VCS_STATUS_COMMITS_BEHIND})"
      # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
      (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && GIT_DIRTY_PART+=""
      (( VCS_STATUS_COMMITS_AHEAD  )) && GIT_DIRTY_PART+="${clean}⇡$(__render_counter ${VCS_STATUS_COMMITS_AHEAD})"
      # ⇠42 if behind the push remote.
      (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_DIRTY_PART+="${clean}⇠$(__render_counter ${VCS_STATUS_PUSH_COMMITS_BEHIND})"
      (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_DIRTY_PART+=""
      # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
      (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && GIT_DIRTY_PART+="${clean}⇢$(__render_counter ${VCS_STATUS_PUSH_COMMITS_AHEAD})"

      # 'merge' if the repo is in an unusual state.
      [[ -n $VCS_STATUS_ACTION     ]] && GIT_DIRTY_PART+="${conflicted}${VCS_STATUS_ACTION}"
      # ~42 if have merge conflicts.
      (( VCS_STATUS_NUM_CONFLICTED )) && GIT_DIRTY_PART+="${conflicted}~$(__render_counter ${VCS_STATUS_NUM_CONFLICTED})"

      if [ $GIT_DIRTY_PART_LESS_DIRTY ]; then
        (( VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED )) && GIT_DIRTY_PART+="$red!"
      else
        # +42 if have staged changes.
        (( VCS_STATUS_NUM_STAGED     )) && GIT_DIRTY_PART+="${modified}+$(__render_counter ${VCS_STATUS_NUM_STAGED})"
        # !42 if have unstaged changes.
        (( VCS_STATUS_NUM_UNSTAGED   )) && GIT_DIRTY_PART+="${modified}!$(__render_counter ${VCS_STATUS_NUM_UNSTAGED})"
        # ?42 if have untracked files. It's really a question mark, your font isn't broken.
        (( VCS_STATUS_NUM_UNTRACKED  )) && GIT_DIRTY_PART+="${untracked}?$(__render_counter ${VCS_STATUS_NUM_UNTRACKED})"
      fi

      # *42 if have stashes.
      (( VCS_STATUS_STASHES        )) && GIT_DIRTY_PART+="${clean}*$(__render_counter ${VCS_STATUS_STASHES})"
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
add-zsh-hook precmd __my_set_prompt


# ---- history ----

setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing non-existent history.

HISTFILE=~/.zsh_history
HISTSIZE=10000  # The maximum number of events to save in the internal history.
SAVEHIST=10000  # The maximum number of events to save in the history file.


# ---- completion ----

# With hidden files
_comp_options+=(globdots)

__zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

ZSH_EXT_FOLDER="$HOME"/.config/zsh-completion
mkdir -p "$ZSH_EXT_FOLDER"

# Clone and compile to wordcode missing plugins.
if [[ ! -e "$ZSH_EXT_FOLDER"/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git  "$ZSH_EXT_FOLDER/zsh-syntax-highlighting"
  __zcompile-many "$ZSH_EXT_FOLDER"/zsh-syntax-highlighting/{zsh-syntax-highlighting,highlighters/*/*.zsh}
fi
if [[ ! -e "$ZSH_EXT_FOLDER"/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_EXT_FOLDER/zsh-autosuggestions"
  __zcompile-many "$ZSH_EXT_FOLDER"/zsh-autosuggestions/{zsh-autosuggestions,src/**/*.zsh}
fi


# Load the Zsh completion system

if [[ ! -e "$ZSH_EXT_FOLDER"/zsh-completions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$ZSH_EXT_FOLDER/zsh-completions"
  fpath=("$ZSH_EXT_FOLDER"/zsh-completions/src $fpath)
  rm -f ~/.zcompdump
fi

autoload -Uz compinit && compinit

unfunction __zcompile-many

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Move cursor to the end of a completed word.
setopt ALWAYS_TO_END

# When a directory is completed, add a trailing slash instead of a space.
setopt AUTO_PARAM_SLASH

# Use the completion system's default options
zstyle ':completion:*' completer _expand _complete _correct _approximate

# Specify the format for the completion menu
zstyle ':completion:*' menu select=1
zstyle ':completion:*:default' list-prompt '%M: %d'

zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Tab completion colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# add new installed packages into completions
zstyle ':completion:*' rehash true

# Show completions for commands that start with a space
zstyle ':completion:*' ignore-parents parent pwd

# Show descriptions for completed commands
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Enable caching of completions
zstyle ':completion:*' use-cache yes

# ==== PROFILING ====

if [ $ZSH_PROFILING -eq 1 ];then zprof; fi

