#!/bin/bash
set -euo pipefail

src=$(find /src -maxdepth 1 -type d -not -path "/src/lost+found" -not -path "/src" | dmenu "$@" -l 5 -i -p "Select a project")
if [[ -z "$src" ]]; then exit 0; fi
WORKDIR="$(cd "$src" && pwd)"

tabbed -n "nvim-project" -c -s st -d "$WORKDIR" -w >/tmp/tabbed.wid &
TABPID=$!

sleep 0.1

WID="$(cat /tmp/tabbed.wid)"

st -t "nvim - $WORKDIR" -w "$WID" -d "$WORKDIR" -e nvim &
sleep 0.1

st -w "$WID" -d "$WORKDIR" -e opencode &

wait "$TABPID"
