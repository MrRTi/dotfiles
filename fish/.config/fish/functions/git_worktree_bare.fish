function git_worktree_bare
    git worktree list | grep bare | awk '{print $1}'
end
