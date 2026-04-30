complete -c barista -f

complete -c barista -n __fish_use_subcommand -a clean   -d 'Untap unused taps'
complete -c barista -n __fish_use_subcommand -a receipt -d 'Dump brew state to file'
complete -c barista -n __fish_use_subcommand -a rebrew  -d 'Restore from dump file'
complete -c barista -n __fish_use_subcommand -a sync    -d 'Add ~/Brewfile to chezmoi'
complete -c barista -n __fish_use_subcommand -a help    -d 'Show help'

complete -c barista -n '__fish_seen_subcommand_from clean' -l dry-run -d 'Preview without removing'

complete -c barista -n '__fish_seen_subcommand_from receipt rebrew' -F
