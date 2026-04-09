function docker_run
    set cmd $argv[2..-1]

    if test (count $cmd) -eq 0
        set cmd bash
    end

    docker run -it --rm $argv[1] $cmd 
end
