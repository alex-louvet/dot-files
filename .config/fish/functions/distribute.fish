function distribute
    set cmd $argv[1]
    for x in $argv[2..]
        $cmd $x &
    end
end
