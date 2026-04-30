# First arg: repo URL — no completion
# Second arg: target directory name
complete -c git_clone_to_worktree -n 'test (count (commandline -opc)) -ge 2' -F
