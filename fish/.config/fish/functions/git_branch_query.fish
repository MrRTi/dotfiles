function git_branch_query
    git branch | sed -r "s:\* (.*):\1 [exists]:" | awk '{printf "\x1b[34m%s\x1b[0m\t\x1b[31m%s\x1b[0m\n", $1, $2}' | fzf --print-query --ansi --query "$argv[1]" | tail -n 1 | awk '{print $1}'
end
