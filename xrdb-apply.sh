#!/usr/bin/bash

DIR=/home/hsmith/.Xresources
echo "Attempting to mere $DIR"
xrdb -merge $DIR
QR=$(xrdb -query)
echo "$QR results of xrdb -query" 
xrdb -query | grep -q 'Xft.dpi'
exit $?
