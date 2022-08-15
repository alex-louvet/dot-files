killall -q polybar

if type "xrandr" ; then
    index=0
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        barname="mainbar$index"
        monitor=$m polybar --reload $barname -q &
        let index=index+1
    done
else
    polybar --reload main &
fi
