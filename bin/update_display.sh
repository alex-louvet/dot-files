#!/bin/fish

xrandr --auto

set -f test false;
if test (xrandr | grep " connected" | wc -l) -ge 2
    for l in (xrandr | grep " connected")
        if $test
            xrandr --output (string sub -l 6 $l) --left-of eDP-1;
        end
        set -f test true;
    end
end



