# NOTE: Abbreviations
abbr --add b bundle
abbr --add be "bundle exec"
abbr --add berc "bundle exec rails c"
abbr --add belint "bundle exec rubocop -a"
abbr --add betest "RAILS_ENV=test bundle exec rspec"

abbr --add c "clear && printf '\e[999B'"

abbr --add d docker
abbr --add dc "docker compose"
abbr --add dcr "docker compose run --rm --use-aliases"
abbr --add dcrs "docker compose run --rm --use-aliases --service-ports"

abbr --add md "mkdir -pv"

abbr --add ll "ls -la"

abbr --add tn tmux-sessionizer

abbr --add v nvim
abbr --add vf "nvim ."

abbr --add k-m1 "sudo kanata -c \"$HOME/.config/kanata/macbook-air-m1.kbd\" -p 4444"
abbr --add k-mon kanata-layer-monitor

abbr --add g git
abbr --add ga "git add"
abbr --add gb "git branch"
abbr --add gc "git commit"
abbr --add gcm "git commit -m "
abbr --add gco "git checkout"
abbr --add gd "git diff"
abbr --add glol "git log-pretty"
abbr --add gpu "git push -u origin (git rev-parse --abbrev-ref HEAD)"
abbr --add grup "git remote update"
abbr --add gs "git status"
abbr --add gw "git worktree"
abbr --add gwa "git worktree add"
abbr --add gwl "git worktree list"
abbr --add gwr "git worktree remove"
abbr --add gwrf "git worktree remove --force"

function git_worktree_root
    git worktree list | grep bare | awk '{print $1}'
end

function git_branch_query
    git branch | sed -r "s:\+ (.*):\1 [exists]:" | awk '{printf "\x1b[34m%s\x1b[0m\t\x1b[31m%s\x1b[0m\n", $1, $2}' | fzf --print-query --ansi --query "$argv[1]" | tail -n 1
end

function git_worktree_add_query
    set branch (git_branch_query "$argv[1]")
    echo "Creating worktree at $branch"
    if git branch | grep -q $branch
        git worktree add (git_worktree_root)/$branch $branch
    else
        git worktree add (git_worktree_root)/$branch -b $branch
    end

    cd (git_worktree_root)/$branch
end

function git_worktree_select
    set root (git_worktree_root)

    git worktree list |
        awk '{printf "\x1b[34m %s\x1b[0m\t\x1b[33m%s\x1b[0m\n", ($3 == "" ? "(root)" : $3), $1}' |
        begin
            if test -n "$root"
                sed "s:$root:󰾛 :"
            else
                cat
            end
        end |
        sed "/ (root)*/d" |
        column -t |
        fzf --ansi --query "$argv[1]" |
        begin
            if test -n "$root"
                sed "s:󰾛  :$root:"
            else
                cat
            end
        end
end

function git_worktree_switch
    set worktree_path (git_worktree_select $argv[1] | awk '{print $3}')
    if test -z "$worktree_path"
        return
    end
    cd "$worktree_path"
end

function find_signing_key
    ssh-add -L | grep "$(git config --get user.email)" | head -n 1
end

function devpod_up_raw
    devpod up . --id "$(basename $(git_worktree_root))--$(basename $(pwd))" --provider kubernetes --debug
end

abbr --add dpuraw devpod_up_raw

function devpod_up
    devpod up . --id "$(basename $(git_worktree_root))--$(basename $(pwd))" --provider kubernetes --debug --devcontainer-path tmp/.devcontainer.json
end

abbr --add dpu devpod_up

function devpod_delete
    devpod delete "$(basename $(git_worktree_root))--$(basename $(pwd))"
end

abbr --add dpd devpod_delete

function fish_greeting
    echo "🐟 Welcome back, captain!"
end

if status is-interactive; and not set -q skip_init_command
    printf '\e[999B'
    set skip_init_command 1
end

# NOTE: Aliases
alias :q=exit
alias re-fish="source ~/.config/fish/config.fish"

if [ -S "$HOME/.1password/agent.sock" ]
    set -gx SSH_AUTH_SOCK_PREV $SSH_AUTH_SOCK
    set -gx SSH_AUTH_SOCK "$HOME/.1password/agent.sock"
end

if type -q bat
    alias cat="bat -pp"
    alias less="bat -p"
    alias lessl="bat -pl"
end

if type -q eza
    alias ls="eza"
end

if type -q emacs
    alias em="emacs --tty"
    alias emd="emacs --daemon"
    alias emc="emacsclient -c -a \"\" --tty"
end

alias gwaq="git_worktree_add_query"
alias gws="git_worktree_switch"

# NOTE: Interactive shell params

fish_vi_key_bindings

set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual block

# NOTE: Add local bin
fish_add_path ~/.local/bin

# NOTE: Add Orbstack
fish_add_path ~/.orbstack/bin

# NOTE: Add yc
fish_add_path ~/yandex-cloud/bin

# NOTE: Add brew
if type -q /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# NOTE: Add linuxbrew
if type -q /home/linuxbrew/.linuxbrew/bin/brew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

# NOTE: Add fzf
if type -q fzf
    fzf --fish | source
end

# NOTE: Add starship
if type -q starship
    starship init fish | source
end

# NOTE: Add mise

if type -q mise
    mise activate fish | source
end

# NOTE: Add direnv

if type -q direnv
    direnv hook fish | source
end

if type -q k9s
    set -gx K9S_CONFIG_DIR $HOME/.config/k9s
    k9s completion fish | source
end
