# ==== PROFILING ====

ZSH_PROFILING=${ZSH_PROFILING:-0}
if [ $ZSH_PROFILING -eq 1 ]; then zmodload zsh/zprof; fi

# ==== HELPERS ====

__command-available() {
  command -v "$1" >/dev/null 2>&1
}

__fzf-preview-tool() {
  if command -v eza > /dev/null 2>&1; then
    echo 'eza'
  else
    echo 'ls'
  fi
}

__red-dim-message() {
  echo "\033[2;31m$1\033[0m"
}

__green-dim-message() {
  echo "\033[2;32m$1\033[0m"
}

__yellow-dim-message() {
  echo "\033[2;33m$1\033[0m"
}

__blue-dim-message() {
  echo "\033[2;34m$1\033[0m"
}

__magenta-dim-message() {
  echo "\033[2;35m$1\033[0m"
}

__dim-message() {
  echo "\033[2m$1\033[0m"
}

# ---- shell aliases  ----

alias ..='cd ..'
alias md='mkdir -pv'
alias ll='ls -la'
alias c='clear'
alias :q='exit'

alias clean_desktop="rm ~/Desktop/*.png"


# ---- zsh aliases  ----

alias rel-env="source $HOME/.zshenv && __magenta-dim-message \"~/.zshenv sourced\""
alias rel-shell="source $HOME/.zshrc  && __magenta-dim-message \"~/.zshrc sourced\""
alias rel-shell-debug="ZSH_PROFILING=1 rel-shell"
alias zshr="rel-env && rel-shell"


# ---- bat ----

if __command-available bat; then
  alias cat='bat -pp'
  alias less='bat -p'
  alias lessl='bat -pl'

  export BAT_THEME="ansi"
fi

# ---- brew ----

if __command-available brew; then
  # To fix gem pg install
  export PATH="$(brew --prefix libpq)/bin:$PATH"

  export LDFLAGS="-L$(brew --prefix zlib)/lib"
  export CPPFLAGS="-I$(brew --prefix zlib)/include"
fi


# ---- cargo ----

if __command-available cargo; then
  export PATH="$HOME/.cargo/bin:$PATH"


  if cargo install --list | grep -q sccache; then
    export RUSTC_WRAPPER=sccache
  fi
fi


# ---- docker ----

if __command-available docker; then
  alias d='docker'
  alias dc='docker compose'
  alias dcr='dc run --rm --use-aliases'
  alias dcrs='dcr --service-ports'
fi

# ---- emacs / doom emacs ----

if [ -d "$HOME/.config/emacs/bin" ]; then
  export PATH="$PATH":"$HOME"/.config/emacs/bin
fi

if __command-available emacs; then
  alias em='emacs --tty'
  # When using emacs daemon menu bar is shown in attached clients. -a "" = if no daemon - run daemon and retry
  alias emacsclient-no-bars='emacsclient -c -e "(progn (scroll-bar-mode -1) (tool-bar-mode -1) (menu-bar-mode -1))" -a ""'
  alias emc='emacsclient-no-bars --tty'
  alias emcd='emacsclient-no-bars'
  alias emd='emacs --daemon'
fi


# ---- eza ----

if __command-available eza; then
  alias ls='eza'
fi


# ---- fzf ----

if __command-available fzf; then
  source <(fzf --zsh)

  # Open in tmux popup if on tmux, otherwise use --height mode
  export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

  # To follow symbolic links and don't want it to exclude hidden files
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
fi


# ---- git ----

if __command-available git; then
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

if __command-available git && __command-available fzf; then
  __git-worktree-root() {
    git worktree list | grep 'bare' | awk '{print $1}'
  }

  __git-branch-query() {
    git branch | \
      sed -r "s:\+ (.*):\1 [exists]:" | \
      awk '{printf "\x1b[34m%s\x1b[0m\t\x1b[31m%s\x1b[0m\n", $1, $2}' | \
      fzf --print-query --ansi --query "$1" | \
      tail -n 1
  }

  __git-worktree-add-query() {
    BRANCH=$(__git-branch-query "$1")
    echo "Creating worktree at ${BRANCH}"
    if git branch | grep -q $BRANCH; then
      git worktree add "$(__git-worktree-root)/${BRANCH}" "${BRANCH}"
    else
      git worktree add "$(__git-worktree-root)/${BRANCH}" -b "${BRANCH}"
    fi

    cd "$(__git-worktree-root)/${BRANCH}"
  }

  alias gwaq="__git-worktree-add-query"

  __select-worktree() {
    ROOT=$(__git-worktree-root)
    git worktree list | \
      awk '{printf "\x1b[34m %s\x1b[0m\t\x1b[33m%s\x1b[0m\n", ($3 == "" ? "(root)" : $3), $1}' | \
      { if [ -n "$ROOT" ]; then sed "s:${ROOT}:󰾛 :"; else cat -; fi } | \
      sed "/ (root)*/d" | \
      column -t | \
      fzf --ansi --query "$1" | \
      { if [ -n "$ROOT" ]; then sed "s:󰾛  :${ROOT}:"; else cat -; fi }
  }

  __select-worktree-branch() {
    __select-worktree "$1" | awk '{print $2}'| sed -r "s:\[(.*)\]:\1:"
  }

  __select-worktree-path() {
    __select-worktree "$1" | awk '{print $3}'
  }

  __git-worktree-delete-query() {
    __select-worktree-path "$1" | basename | xargs -0 git worktree remove
  }

  alias gwdq="__git-worktree-delete-query"

  __git-worktree-delete-force-query() {
    __select-worktree-path "$1" | basename | xargs -0 git worktree remove --force
  }

  alias gwdqf="__git-worktree-delete-force-query"

  __git-worktree-switch() {
    WORKTREE_PATH="$(__select-worktree-path $1)"

    if [ -z "$WORKTREE_PATH" ]; then return; fi

    cd "${WORKTREE_PATH}"
  }

  alias gws="__git-worktree-switch"
fi


# ---- k9s ----

if __command-available k9s; then
  export K9S_CONFIG_DIR="$HOME/.config/k9s"
fi


# ---- mice ----

if __command-available mise; then
  eval "$(mise activate zsh)"
fi


# ---- nvim ----

if __command-available nvim; then
  alias vim=nvim
  alias v=vim
  alias vf='vim .'
fi


# ---- tldr ----

if __command-available tldr && __command-available fzf; then
  alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
fi


# ---- tmux ----

if __command-available tmux-sessionizer; then
  alias tn='tmux-sessionizer'
fi


# ==== ZSH CONFIG ====

export EDITOR="vim"
export VISUAL="vim"

# ---- vi-mode ----

# Enable vi mode
bindkey -v
export KEYTIMEOUT=1

# Update cursor when in insert mode
__render-block() {
  echo -ne '\e[2 q'
}

__render-beam() {
  echo -ne '\e[6 q'
}

zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    __render-block
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    __render-beam
  fi
}

zle-line-init() {
  __render-beam
}

zle -N zle-keymap-select
zle -N zle-line-init

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

__source-gitstatus() {
  GIT_STATUS_FOLDER="$HOME"/.local/gitstatus

  if [ ! -d "$GIT_STATUS_FOLDER"/ ]; then
    mkdir -pv "$GIT_STATUS_FOLDER"
    git clone --depth=1 https://github.com/romkatv/gitstatus.git "$GIT_STATUS_FOLDER"
  fi

  source "$GIT_STATUS_FOLDER"/gitstatus.plugin.zsh
}

__source-gitstatus
unfunction __source-gitstatus

NEWLINE=$'\n'
GIT_PROMPT_COUNTERS=${GIT_PROMPT_COUNTERS:=false}
GIT_PROMPT_LESS_DIRTY=${GIT_PROMPT_LESS_DIRTY:=true}

__render-counter() {
  $GIT_PROMPT_COUNTERS && printf "$1 "
}

__prompt() {
  PROMPT=""

  if [ -n "$TMUX" ]; then
    PROMPT+="%F{cyan} "
  fi

  # NOTE: User & host name
  if [ -z $TMUX ]; then
    PROMPT+="%F{cyan}%n@%m"
  fi

  PROMPT+=" "

  FOLDER_PART="%F{yellow}%(5~|%-1~/…/%2~|%3~)"
  PROMPT+="$FOLDER_PART"

  IS_GIT_FOLDER=$(git rev-parse --is-inside-repository >/dev/null 2>&1 && echo "true" || echo "false")

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
      (( VCS_STATUS_COMMITS_BEHIND )) && GIT_DIRTY_PART+="${clean}⇣$(__render-counter ${VCS_STATUS_COMMITS_BEHIND})"
      # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
      (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && GIT_DIRTY_PART+=""
      (( VCS_STATUS_COMMITS_AHEAD  )) && GIT_DIRTY_PART+="${clean}⇡$(__render-counter ${VCS_STATUS_COMMITS_AHEAD})"
      # ⇠42 if behind the push remote.
      (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_DIRTY_PART+="${clean}⇠$(__render-counter ${VCS_STATUS_PUSH_COMMITS_BEHIND})"
      (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && GIT_DIRTY_PART+=""
      # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
      (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && GIT_DIRTY_PART+="${clean}⇢$(__render-counter ${VCS_STATUS_PUSH_COMMITS_AHEAD})"

      # 'merge' if the repo is in an unusual state.
      [[ -n $VCS_STATUS_ACTION     ]] && GIT_DIRTY_PART+="${conflicted}${VCS_STATUS_ACTION}"
      # ~42 if have merge conflicts.
      (( VCS_STATUS_NUM_CONFLICTED )) && GIT_DIRTY_PART+="${conflicted}~$(__render-counter ${VCS_STATUS_NUM_CONFLICTED})"

      if [ $GIT_DIRTY_PART_LESS_DIRTY ]; then
        (( VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED )) && GIT_DIRTY_PART+="$red!"
      else
        # +42 if have staged changes.
        (( VCS_STATUS_NUM_STAGED     )) && GIT_DIRTY_PART+="${modified}+$(__render-counter ${VCS_STATUS_NUM_STAGED})"
        # !42 if have unstaged changes.
        (( VCS_STATUS_NUM_UNSTAGED   )) && GIT_DIRTY_PART+="${modified}!$(__render-counter ${VCS_STATUS_NUM_UNSTAGED})"
        # ?42 if have untracked files. It's really a question mark, your font isn't broken.
        (( VCS_STATUS_NUM_UNTRACKED  )) && GIT_DIRTY_PART+="${untracked}?$(__render-counter ${VCS_STATUS_NUM_UNTRACKED})"
      fi

      # *42 if have stashes.
      (( VCS_STATUS_STASHES        )) && GIT_DIRTY_PART+="${clean}*$(__render-counter ${VCS_STATUS_STASHES})"
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
add-zsh-hook precmd __prompt


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

# Load the Zsh completion system

if [[ ! -e "$ZSH_EXT_FOLDER"/zsh-completions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$ZSH_EXT_FOLDER/zsh-completions"
  fpath=("$ZSH_EXT_FOLDER"/zsh-completions/src $fpath)
  rm -f ~/.zcompdump
fi


if [[ -e "$(brew --prefix)/share/zsh/site-functions" ]]; then
  fpath+="$(brew --prefix)/share/zsh/site-functions"
fi

autoload -Uz compinit
compinit

if [[ ! -e "$ZSH_EXT_FOLDER"/fzf-tab ]]; then
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git "$ZSH_EXT_FOLDER/fzf-tab"
fi

source "$ZSH_EXT_FOLDER"/fzf-tab/fzf-tab.plugin.zsh


# Clone and compile to wordcode missing plugins.
if [[ ! -e "$ZSH_EXT_FOLDER"/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git  "$ZSH_EXT_FOLDER/zsh-syntax-highlighting"
  __zcompile-many "$ZSH_EXT_FOLDER"/zsh-syntax-highlighting/{zsh-syntax-highlighting,highlighters/*/*.zsh}
fi

if [[ ! -e "$ZSH_EXT_FOLDER"/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_EXT_FOLDER/zsh-autosuggestions"
  __zcompile-many "$ZSH_EXT_FOLDER"/zsh-autosuggestions/{zsh-autosuggestions,src/**/*.zsh}
fi

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Move cursor to the end of a completed word.
setopt ALWAYS_TO_END

# When a directory is completed, add a trailing slash instead of a space.
setopt AUTO_PARAM_SLASH

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview "$(__fzf-preview-tool) -1 --color=always \$realpath"
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

unfunction __zcompile-many

# ==== PROFILING ====

if [ $ZSH_PROFILING -eq 1 ]; then zprof; fi

