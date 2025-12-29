#!/bin/bash

# Get current track from Mopidy (default port 6680)
TRACK=$(curl -s -X POST http://localhost:6680/mopidy/rpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "core.playback.get_current_track"}' \
  | jq -r '.result')

ARTIST=$(echo "$TRACK" | jq -r '.artists[0].name')
TITLE=$(echo "$TRACK" | jq -r '.name')
ALBUM=$(echo "$TRACK" | jq -r '.album.name')

notify-send -a NCMPCPP "$ARTIST - $TITLE" "$ALBUM"
