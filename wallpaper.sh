#!/bin/bash

WDIR=/home/hsmith/Pictures/WallpapersAnime
LFILE=/tmp/lock

W=$(ls $WDIR | sort -R | tail -1)

cp "$WDIR/$W" "$LFILE"
if [ "${RUNNING_UNDER_SYSTEMD:-0}" -eq 1 ]; then
  sleep 1
fi

feh --bg-scale "$WDIR/$W"
