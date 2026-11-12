# Non-interactive guard
status is-interactive || return

# Environment variables and PATH
# fish_add_path skips directories that don't exist, so this line also works in
# sbx boxes (no Homebrew, no OrbStack).
fish_add_path /opt/homebrew/bin $HOME/.local/bin $HOME/.orbstack/bin $CARGO_HOME/bin

# 1Password's agent and Homebrew's libpq exist only on the host. Checks the
# app, not the socket: shells (and the tmux server) restored at login start
# before 1Password has created the socket, and would keep the macOS agent.
test -d /Applications/1Password.app; and set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock
if test -d /opt/homebrew/opt/libpq
    set -gx LDFLAGS "-L/opt/homebrew/opt/libpq/lib"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/libpq/include"
end
set -gx EDITOR nvim
set -gx VISUAL nvim

# Tool integrations
# NOTE: no `mise activate` here. conf.d/mise-activate.fish runs it before this
# file in every shell; repeating it here ran it twice (mise's status line
# printed twice, ~17 ms of a ~140 ms startup).

# Vi mode and cursor shapes
# fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_visual block
set fish_cursor_replace_one underscore

# Git prompt settings (mirrors GIT_PS1_SHOW* in bash)
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream auto
set -g __fish_git_prompt_color yellow

# Aliases (command overrides — wrap same-named commands)
alias lsd='lsd --git --icon never'
alias ls='lsd'
alias la='ls -a'
alias lt='ls --tree'
alias ll='ls -la'
alias less='bat -p'
alias lessl='bat -pl'
alias cat='bat -pp'
alias reload='exec fish'

alias opr=op_run_with_env

# Abbreviations
abbr --add b bundle
abbr --add be 'bundle exec'
abbr --add brc 'bundle exec rails c'
abbr --add ber 'bundle exec rspec'
abbr --add bdr 'bundle exec rails db:rollback'
abbr --add bdm 'bundle exec rails db:migrate'
abbr --add c clear
abbr --add clean_desktop 'rm ~/Desktop/*.png'
abbr --add cz chezmoi
abbr --add cza 'chezmoi apply'
abbr --add czd 'chezmoi diff'
abbr --add d docker
abbr --add dc 'docker compose'
abbr --add dcu 'docker compose up'
abbr --add dcud 'docker compose up -d'
abbr --add dcr 'docker compose run --rm --use-aliases'
abbr --add dcrs 'docker compose run --rm --use-aliases --service-ports'
abbr --add db 'docker_build'
abbr --add dr 'docker_run'
abbr --add fxa 'fnox activate fish | source'
abbr --add fxd 'fnox deactivate'
abbr --add g git
abbr --add ga 'git add'
abbr --add gb 'git branch'
abbr --add gc 'git commit'
abbr --add gco 'git checkout'
abbr --add glol 'git log-pretty'
abbr --add gpf 'git push --force-with-lease origin (git current-branch)'
abbr --add gpu 'git push -u origin (git current-branch)'
abbr --add gres 'git reset --hard origin/(git current-branch)'
abbr --add grup 'git remote update'
abbr --add gs 'git status'
abbr --add gw 'git worktree'
abbr --add gwa git_worktree_add_query
abbr --add gwb git_worktree_base
abbr --add gwr git_worktree_remove
abbr --add gws git_worktree_switch
abbr --add hl 'rg --passthru'
abbr --add md 'mkdir -pv'
abbr --add tn tmux-sessionizer
abbr --add v nvim
abbr --add vf 'nvim .'
abbr --add -- - 'cd -'
abbr --add ':q' exit
