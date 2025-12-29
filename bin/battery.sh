#!/bin/bash
charging=$(cat /sys/class/power_supply/AC/online)

#Compute total percentage
total_per=0
total_capacity=0
total_consumption=0
for battery in /sys/class/power_supply/BAT*;
do
    total_per=$(($total_per+$(cat $battery"/energy_now")))
    total_capacity=$(($total_capacity+$(cat $battery"/energy_full")))
    total_consumption=$(($total_consumption+$(cat $battery"/power_now")))
done

if [[ $total_consumption -gt 0 ]];
then
    left_h=$((total_per/total_consumption))
    left_m=$(((total_per - total_consumption * left_h)*60/10000000))
    if [[ $left_m -lt 10 ]];
    then
        left_m="0"$left_m
    fi
    left="("$left_h":"$left_m")"
else
    left=""
fi
total_per=$((100*total_per/total_capacity))

if [[ $charging = "1" ]];
then
    if [[ $total_per -gt 96 ]];
    then
        echo " 100%"
    elif [[ $total_per -gt 90 ]];
    then
        echo " "$total_per"%"
    elif [[ $total_per -gt 80 ]];
    then
        echo " "$total_per"%"

    elif [[ $total_per -gt 60 ]];
    then
        echo " "$total_per"%"

    elif [[ $total_per -gt 40 ]];
    then
        echo " "$total_per"%"

    elif [[ $total_per -gt 30 ]];
    then
        echo " "$total_per"%"

    else
        echo " "$total_per"%"

    fi

else
    if [[ $total_per -gt 96 ]];
    then
        echo " 100% "$left
    elif [[ $total_per -gt 90 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 80 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 70 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 60 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 50 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 40 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 30 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 20 ]];
    then
        echo " "$total_per"% "$left

    elif [[ $total_per -gt 10 ]];
    then
        echo " "$total_per"% "$left

    else
        echo " "$total_per"% "$left

    fi
fi
