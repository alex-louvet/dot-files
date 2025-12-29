function search_in_file --argument txt path
for f in $path/*
if test -f $f
if test 0 -lt (cat $f | grep $txt | count)
echo "> $f"
cat $f | grep $txt
echo
end
end
end
end
