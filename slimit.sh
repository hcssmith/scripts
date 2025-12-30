#!/bin/sh
set -eu

# Usage: slimit <name> <service-to-trigger> [max-retries]
# Example: slimit xrdb x11-kill.service 5

NAME="$1"
TRIGGER="$2"
MAX_RETRIES="${3:-5}"  # default to 5 if not passed

STATE_FILE="/tmp/slimit-${NAME}.count"

# read current count
count=0
if [ -f "$STATE_FILE" ]; then
    count=$(cat "$STATE_FILE")
fi

# increment counter
count=$((count + 1))
echo "$count" > "$STATE_FILE"

# check if we hit limit
if [ "$count" -ge "$MAX_RETRIES" ]; then
    echo "[$(date)] ${NAME} reached max retries (${MAX_RETRIES}), triggering ${TRIGGER}" >&2
    systemctl --user start "$TRIGGER"
    # optional: reset counter so future retries start fresh
    #rm -f "$STATE_FILE"
fi
