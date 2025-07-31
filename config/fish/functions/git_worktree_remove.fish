function git_worktree_remove
    git worktree list | awk '{print $1}' | fzf --multi | while read line
        git worktree remove --force $line
    end
end
