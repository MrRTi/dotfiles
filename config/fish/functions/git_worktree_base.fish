function git_worktree_base
    set git_dir (git rev-parse --show-toplevel 2>/dev/null) || if test -d ./main/.git
        # NOTE: to be able to use git command in root project folder
        cd main
        set git_dir (git rev-parse --show-toplevel)
    end

    if test -d "$git_dir/.git"
        dirname $git_dir
        return 0
    end

    if test -f "$git_dir/.git"
        cat .git | awk '{print $2}' | string split '/.git/worktrees' | head -n1 | xargs dirname
        return 0
    end

    echo "Not git repository"
    return 1
end
