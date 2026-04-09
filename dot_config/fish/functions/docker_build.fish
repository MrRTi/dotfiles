function docker_build
    docker build -t $argv[1] $argv[2..-1] .
end
