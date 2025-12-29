#!/bin/sh
# Toggle between tiled and floating modes in bspwm

focused_node=$(bspc query -N -n focused)

# Exit if no focused node
[ -z "$focused_node" ] && exit 0

# Check if window is floating
if bspc query -N -n "${focused_node}.floating" >/dev/null 2>&1; then
    # --- It's floating, make it tiled ---
    bspc node "$focused_node" -t tiled
else
    # --- It's tiled, make it floating ---
    bspc node "$focused_node" -t floating
    # Optional: center and resize floating window a bit
    bspc node "$focused_node" --move-to-center
    bspc node "$focused_node" --resize bottom_right 0 -20
fi
