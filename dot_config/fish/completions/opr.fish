complete -c opr -f -a '(complete -C (commandline | string replace -r "^\\S+\\s*" ""))'

