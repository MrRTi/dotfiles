function git_repo_name
    basename -s .git (git config --get remote.origin.url)
end
