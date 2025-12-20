function git_clone_with_worktree
    git clone "$argv[1]" "$argv[2]"/main
    cd "$argv[2]"
    touch .envrc
    echo source_up >>.envrc
    direnv allow
    cd main
end
