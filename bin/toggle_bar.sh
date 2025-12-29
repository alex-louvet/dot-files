#!/bin/bash

export SCRIPTPATH=/home/alexandre/.config/leftwm/themes/catppuccin
cd $SCRIPTPATH

if [[ $(pgrep polybar) ]];
then
    pkill polybar &
else
    index=0
    monitor="$(polybar -m | grep +0+0 | sed s/:.*// | tac)"
    leftwm-state -q -n -t $SCRIPTPATH/sizes.liquid | sed -r '/^\s*$/d' | \
    while read -r width x y
    do 
        barname="mainbar$index"
        monitor="$(polybar -m | awk -v i="$(( index + 1 ))" 'NR==i{print}' | sed s/:.*// | tr -d '\n')"
        monitor=$monitor width=$(( width - 30 )) polybar -c $SCRIPTPATH/polybar.config $barname &
        let index=index+1
    done
fi
