#!/usr/bin/fish

killall -q polybar
set randr (string split " " (xrandr --query | grep " connected" | cut -d" " -f1))
set -f index (count $randr)
set -f max (count $randr)
while test $index -gt 0
    if test $index -lt $max
        set barname "i3b"
    else
        set barname "i3a"
    end
    monitor=$randr[$index] polybar --config="~/.config/polybar/config.ini" --reload $barname -q &
    set -f index (math $index - 1)
end
