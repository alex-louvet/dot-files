#!/bin/bash
white=""
pink=""
brown=""
rain=""
nature=""

LPATH="$( cd "$(dirname "$0")" ; pwd -P )"
LOCATION="center"

rofi_cmd="rofi -theme $LPATH/rasi/powermenu.rasi"
options="$nature\n$white\n$brown\n$rain\n$pink"

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
$rain)
    cd /home/alexandre/Music/Ambient/Rain
    ls |sort -R |tail -$N |while read file; do
        alacritty -e play $file
        break
    done;;
$nature)
    cd /home/alexandre/Music/Ambient/Nature
    ls |sort -R |tail -$N |while read file; do
        alacritty -e play $file
        break
    done;;
esac
