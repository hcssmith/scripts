#!/bin/bash

DIR_STATEFILE=${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper_dir
PICTURES_DIR="$HOME/Pictures"

SUPPORTED_TYPES=("jpg" "jpeg" "png" "gif" "webp" "avif")

# Find Wallpaper* directories in ~/Pictures
dirs=$(find "$PICTURES_DIR" -maxdepth 1 -type d -name "Wallpaper*" -exec basename {} \; | sort)

if [ -z "$dirs" ]; then
  notify-send -u critical "Wallpaper Chooser" "No Wallpaper* folders found in $PICTURES_DIR"
  exit 1
fi

# Show current selection as prompt hint
current=""
[ -f "$DIR_STATEFILE" ] && current=" [$(basename "$(cat "$DIR_STATEFILE")")]"
prompt="Select wallpaper folder${current}:"

# Build menu with count of images per folder
menu=""
while read -r dir; do
  find_args=()
  for ext in "${SUPPORTED_TYPES[@]}"; do
    find_args+=(-o -name "*.$ext")
  done
  find_args=("${find_args[@]:1}")  # drop leading -o
  count=$(find "$PICTURES_DIR/$dir" -maxdepth 1 -type f \( "${find_args[@]}" \) | wc -l)
  menu="${menu}${dir} (${count})\n"
done <<< "$dirs"

selected=$(echo -e "$menu" | dmenu "$@" -i -l "$(echo "$dirs" | wc -l)" -p "$prompt" || exit 0)

# Strip count suffix to get folder name
folder=$(echo "$selected" | sed 's/ ([0-9]*)$//')

if [ -z "$folder" ]; then
  exit 0
fi

full_path="$PICTURES_DIR/$folder"

if [ ! -d "$full_path" ]; then
  notify-send -u critical "Wallpaper Chooser" "Directory not found: $full_path"
  exit 1
fi

mkdir -p "$(dirname "$DIR_STATEFILE")"
echo "$full_path" > "$DIR_STATEFILE"
notify-send "Wallpaper Chooser" "Switched to <b>$folder</b>"
wallpaper.sh
