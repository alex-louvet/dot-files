#!/bin/bash

if $(dunstctl is-paused);
then
    dunstctl close-all
    dunstctl set-paused false
    notify-send -a "Dunst" -i preferences-desktop-notification-bell "unmute"
else
    notify-send -a "Dunst" -i preferences-desktop-notification-bell "mute"
    sleep 1
    dunstctl set-paused true
fi
