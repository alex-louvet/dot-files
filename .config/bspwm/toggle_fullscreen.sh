#!/bin/sh
# Reliable fullscreen toggle for bspwm

focused_node=$(bspc query -N -n focused)

# No focused window
[ -z "$focused_node" ] && exit 0

# Check if fullscreen
if bspc query -N -n "${focused_node}.fullscreen" >/dev/null 2>&1; then
    # --- It's fullscreen, so restore previous state ---
    bspc node "$focused_node" -t tiled || bspc node "$focused_node" -t floating
else
    # --- Not fullscreen, make fullscreen ---
    bspc node "$focused_node" -t fullscreen
fi

