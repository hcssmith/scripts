#!/bin/bash

WDIR=/home/hsmith/Pictures/Wallpapers

W=$(ls $WDIR | sort -R | tail -1)

sleep 1

feh --bg-scale "$WDIR/$W"
