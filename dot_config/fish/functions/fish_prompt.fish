function fish_prompt
    set -l last_status $status
    set -l worktree_icon (printf '\uf1bb') # nf-fa-tree

    # Path
    echo -n (set_color blue)(prompt_pwd --full-length-dirs 1)(set_color normal)

    # Git info — deduplicate branch name when dir name matches branch suffix
    set -l git_info (__fish_git_prompt " (%s)")
    if test -n "$git_info"
        set -l branch (git branch --show-current 2>/dev/null)
        set -l dir_name (basename (pwd))
        if test -n "$branch"; and string match -q "*/$dir_name" "$branch"
            # Branch fully encoded in path — replace branch name with worktree icon
            set git_info (string replace "$branch" "$worktree_icon" $git_info)
        end
        echo -n (set_color yellow)$git_info(set_color normal)
    end

    # Prompt character ($ for normal user, # for root)
    if test (id -u) -eq 0
        echo -n " # "
    else
        echo -n " \$ "
    end
end
