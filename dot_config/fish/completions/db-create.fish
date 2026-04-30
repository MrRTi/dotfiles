complete -c db-create -f

# First arg: db type
complete -c db-create -n 'test (count (commandline -opc)) -eq 1' \
    -a 'postgres' -d 'PostgreSQL'
complete -c db-create -n 'test (count (commandline -opc)) -eq 1' \
    -a 'mysql' -d 'MySQL'
complete -c db-create -n 'test (count (commandline -opc)) -eq 1' \
    -a 'mongo' -d 'MongoDB'

# Second arg: db name (free text, re-enable files implicitly by not blocking)
complete -c db-create -n 'test (count (commandline -opc)) -ge 2' -f
