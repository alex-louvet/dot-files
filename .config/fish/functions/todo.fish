function todo

set -f current (pwd)
cd ~/Seafile/wiki/;
search_in_file "\- \[ \]" .
for f in ./*
if test -d $f
search_in_file "\- \[ \]" $f
end
end
cd $current
end
