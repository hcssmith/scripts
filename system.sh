#!/bin/bash

commands="󰐥 Poweroff\n󰓛 Suspend\n Quit X"

selected=$(echo -e "$commands" | dmenu "$@" -l 3 -i -p "Action:" || exit 0)

case "$selected" in
"󰐥 Poweroff")
  poweroff
  ;;
"󰓛 Suspend")
	xdotool key --clearmodifiers Super+Escape
	xdotool key --clearmodifiers Super+b
  systemctl suspend
  ;;
" Quit X")
  systemctl --user stop x11
  ;;
esac
