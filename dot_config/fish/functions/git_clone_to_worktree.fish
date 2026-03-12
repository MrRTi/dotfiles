function git_clone_to_worktree
    set -l path (command git_clone_to_worktree $argv)
    test -z "$path"; and return 1
    cd $path
end
