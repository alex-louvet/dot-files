#!/bin/sh

# Detect connected monitors
MONITORS=$(bspc query -M --names)

# Reset all desktops (optional safety)
bspc wm -r

# Get monitor count
MON_COUNT=$(echo "$MONITORS" | wc -l)

if [ "$MON_COUNT" -eq 1 ]; then
    # --- Single monitor setup ---
    MON=$(echo "$MONITORS")
    echo "Single monitor: $MON"

    # Assign 10 workspaces (desktops)
    bspc monitor "$MON" -d 1 2 3 4 5 6 7 8 9 10

else
    # --- Multi-monitor setup ---
    MON1=$(echo "$MONITORS" | sed -n 1p)
    MON2=$(echo "$MONITORS" | sed -n 2p)

    echo "Dual monitor setup: $MON1 and $MON2"

    # Assign 5 desktops per monitor
    bspc monitor "$MON1" -d 1 2 3 4 5
    bspc monitor "$MON2" -d 6 7 8 9 10
fi

