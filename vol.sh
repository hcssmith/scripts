#!/bin/bash

mute=$(amixer get Master | grep "Front Left:" | awk -F' ' '{print $6}' | sed 's/[][]//g')
vol=$(amixer get Master | grep "Front Left:" | awk -F' ' '{print $5}' | sed 's/[][]//g')

if [ "$mute" == "off" ]; then
  echo "---"
  exit 0
else
  echo "$vol"
  exit 0
fi
