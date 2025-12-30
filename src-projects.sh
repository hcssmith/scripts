#!/bin/bash

src=$(find /src -maxdepth 1 -type d -not -path "/src/lost+found" -not -path "/src" | dmenu "$@" -l 5 -i -p "Select a project")
if [[ -z "$src" ]]; then exit 0; fi
cd "$src" || exit
neovide --x11-wm-class "nvim-project"
