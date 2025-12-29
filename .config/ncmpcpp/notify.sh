#!/bin/bash

# ncmpcpp passes song info as arguments when configured properly
# Or we can read directly from ncmpcpp
ARTIST="$1"
TITLE="$2"
ALBUM="$3"

notify-send "Now Playing" "$ARTIST - $TITLE\n$ALBUM"
