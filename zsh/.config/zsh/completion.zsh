#!/usr/bin/env zsh

# With hidden files
_comp_options+=(globdots) 

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Load the Zsh completion system
autoload -U compinit
compinit

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
