# Non-interactive guard
status is-interactive || return

# Environment variables and PATH
fish_add_path /opt/homebrew/bin $HOME/.local/bin $HOME/.orbstack/bin $HOME/.cargo/bin

set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock
set -gx LDFLAGS "-L/opt/homebrew/opt/libpq/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/libpq/include"
set -gx EDITOR nvim
set -gx VISUAL nvim

# Tool integrations
if command -q mise
    mise activate fish | source
end

if command -q direnv
    direnv hook fish | source
end

# Vi mode and cursor shapes
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_visual block
set fish_cursor_replace_one underscore

# Git prompt settings (mirrors GIT_PS1_SHOW* in bash)
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream auto
set -g __fish_git_prompt_color yellow

# Aliases (command overrides — wrap same-named commands)
alias eza='eza --git'
alias ls='eza'
alias la='ls -a'
alias lt='ls --tree'
alias ll='ls -la'
alias less='bat -p'
alias lessl='bat -pl'
alias cat='bat -pp'
alias reload='exec fish'

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
abbr --add da 'direnv allow'
abbr --add dc 'docker compose'
abbr --add dcu 'docker compose up'
abbr --add dcud 'docker compose up -d'
abbr --add dcr 'docker compose run --rm --use-aliases'
abbr --add dcrs 'docker compose run --rm --use-aliases --service-ports'
abbr --add db 'docker_build'
abbr --add dr 'docker_run'
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
abbr --add gwr git_worktree_remove
abbr --add gws git_worktree_switch
abbr --add hl 'rg --passthru'
abbr --add md 'mkdir -pv'
abbr --add tn tmux-sessionizer
abbr --add v nvim
abbr --add vf 'nvim .'
abbr --add -- - 'cd -'
abbr --add ':q' exit

