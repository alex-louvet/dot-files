#!/bin/bash
white="⛅"
pink="🌧️"
brown="🌩️"

LPATH="$( cd "$(dirname "$0")" ; pwd -P )"
LOCATION="center"

rofi_cmd="rofi -theme $LPATH/rasi/powermenu.rasi"
options="$white\n$pink\n$brown"

chosen="$(echo -e "$options" | \
$rofi_cmd -dmenu \
-theme-str 'window {location: '$LOCATION';}' \
-selected-row 2\
)"

case $chosen in 
$white)
    alacritty -e fish -c whitenoise;;
$pink)
    alacritty -e fish -c pinknoise;;
$brown)
    alacritty -e fish -c brownnoise;;
esac
