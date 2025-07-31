function git_worktree_select
    set root (git_worktree_base)

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
