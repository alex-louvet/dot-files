#!/bin/fish

function local_search_in_file --argument txt path
for f in $path/*
if test -f $f
if test 0 -lt (cat $f | grep $txt | count)
echo (string collect "\n\n" "#" $f)
cat $f | grep $txt
end
end
end
end

function local_doing
set -f current (pwd)
cd ~/Seafile/wiki/;
local_search_in_file "\- \[-\]" .
for f in ./*
if test -d $f
local_search_in_file "\- \[-\]" $f
end
end
cd $current
end

notify-send -t 100000 -a "TODO" "DOING:" (echo (string replace --all -- "- [-]" "\n [ ]" -- (local_doing)) | string collect)
