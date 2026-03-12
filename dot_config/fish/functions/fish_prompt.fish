function fish_prompt
    # SSH info (green) when connected via SSH
    set -l ssh_info ''
    if set -q SSH_TTY
        set ssh_info (set_color green)(whoami)@(hostname)(set_color normal)':'
    end

    # Path in blue using __short_path script
    set -l path_str (set_color blue)(__short_path)(set_color normal)

    # Git status in yellow
    set -l git_str (fish_git_prompt ' (%s)')

    echo -n $ssh_info$path_str$git_str
    echo ''
    echo -n '$ '
end
