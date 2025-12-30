#!/bin/bash

iw dev wlp59s0 info | grep ssid | sed s/ssid//g | sed 's/^[[:space:]]*//g'
