#!/bin/bash

if [ -n "$(pgrep -x hypridle)" ];
then
    pkill hypridle
else
    hypridle &
fi
