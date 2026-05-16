#!/usr/bin/bash

result=$(nmcli -t -f NAME,TYPE con show --active | awk -F: '$2=="wireguard" {print $1}')
echo "${result:- }"
