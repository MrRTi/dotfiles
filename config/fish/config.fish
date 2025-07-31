status is-interactive; and begin
    # Abbreviations
    abbr --add -- b bundle
    abbr --add -- be 'bundle exec'
    abbr --add -- c 'clear && printf '\''\e[999B'\'''
    abbr --add -- d docker
    abbr --add -- dc 'docker compose'
    abbr --add -- dcr 'docker compose run --rm --use-aliases'
    abbr --add -- dcrs 'docker compose run --rm --use-aliases --service-ports'
    abbr --add -- g git
    abbr --add -- ga 'git add'
    abbr --add -- gb 'git branch'
    abbr --add -- gc 'git commit'
    abbr --add -- gco 'git checkout'
    abbr --add -- gd 'git diff'
    abbr --add -- glol 'git log-pretty'
    abbr --add -- gpf 'git push --force origin (git current-branch)'
    abbr --add -- gpu 'git push -u origin (git current-branch)'
    abbr --add -- gres 'git reset --hard origin/(git current-branch)'
    abbr --add -- grup 'git remote update'
    abbr --add -- gs 'git status'
    abbr --add -- gw 'git worktree'
    abbr --add -- gwa 'git worktree add'
    abbr --add -- gwl 'git worktree list'
    abbr --add -- gwr 'git worktree remove'
    abbr --add -- gwrf 'git worktree remove --force'
    abbr --add -- md 'mkdir -pv'
    abbr --add -- tn tmux-sessionizer
    abbr --add -- v nvim
    abbr --add -- vf 'nvim .'

    # Aliases
    alias ... 'cd ../..'
    alias :q exit
    alias cat 'bat -pp'
    alias clean_desktop 'rm ~/Desktop/*.png'
    alias eza 'eza --git'
    alias gwaq git_worktree_add_query
    alias gwrfzf git_worktree_remove
    alias gws git_worktree_switch
    alias la 'eza -a'
    alias less 'bat -p'
    alias lessl 'bat -pl'
    alias ll 'ls -la'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'
    alias tldrf 'tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
    alias vimdiff 'nvim -d'

    fzf --fish | source

    if status is-interactive; and not set -q skip_init_command
        printf '\e[999B'
        set skip_init_command 1
    end

    fish_vi_key_bindings

    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block

    set -U fish_user_paths ~/.local/bin $fish_user_paths
    set -U fish_user_paths ~/.orbstack/bin $fish_user_paths

    set SSH_AUTH_SOCK ~/.1password/agent.sock

    if test "$TERM" != dumb
        starship init fish | source
        enable_transience
    end

    mise activate fish | source

    direnv hook fish | source
end

# brew related
set -gx LDFLAGS "-L/opt/homebrew/opt/libpq/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/libpq/include"
