function git_worktree_add_query
    set -l path (command git_worktree_add_query $argv[1])
    test -z "$path"; and return 0
    cd $path
end
