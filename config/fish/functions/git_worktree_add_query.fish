function git_worktree_add_query
    set branch (string trim (git_branch_query "$argv[1]"))
    echo "Creating worktree at '$branch'"
    if git branch | grep -q $branch
        git worktree add (git_worktree_base)/$branch $branch
    else
        git worktree add (git_worktree_base)/$branch -b $branch
    end

    cd (git_worktree_base)/$branch
end
