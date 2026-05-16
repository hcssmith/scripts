#!/bin/bash

STATEFILE=/tmp/wallpaper_last
DIR_STATEFILE=${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper_dir
DEFAULT_WDIR="$HOME/Pictures/WallpapersCOM"

if [ -f "$DIR_STATEFILE" ] && [ -d "$(cat "$DIR_STATEFILE")" ]; then
  WDIR=$(cat "$DIR_STATEFILE")
else
  WDIR="$DEFAULT_WDIR"
fi

LFILE=/tmp/lock

PREV=""
[ -f "$STATEFILE" ] && PREV=$(cat "$STATEFILE")

# Pick a random wallpaper, excluding the previous one
W=$(ls "$WDIR" | grep -vFx "$PREV" | sort -R | tail -1)

# Fallback if only one wallpaper exists
[ -z "$W" ] && W=$(ls "$WDIR" | sort -R | tail -1)

cp "$WDIR/$W" "$LFILE"
echo "$W" > "$STATEFILE"

if [ "${RUNNING_UNDER_SYSTEMD:-0}" -eq 1 ]; then
  sleep 1
fi

feh --bg-scale "$WDIR/$W"
