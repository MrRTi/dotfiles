function git_worktree_switch
    set -l path (git_worktree_select $argv[1])
    test -z "$path"; and return 1
    cd $path
end
