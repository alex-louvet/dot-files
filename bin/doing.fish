#!/bin/fish

function local_search_in_file --argument txt path
for f in $path/*
if test -f $f
if test 0 -lt (cat $f | grep $txt | count)
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

echo  (local_doing | wc -l)
