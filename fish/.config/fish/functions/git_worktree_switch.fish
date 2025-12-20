function git_worktree_switch
    set worktree_path (git_worktree_select $argv[1] | awk '{print $3}')
    if test -z "$worktree_path"
        return
    end
    cd "$worktree_path"
end
