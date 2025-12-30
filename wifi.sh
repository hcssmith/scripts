#!/bin/sh


#commands="Disconnect from Network\nConnect to Network"

commands="Disconnect from Network\nConnect to Network\nEnable VPN\nDisable VPN"

action=$(echo -e $commands | dmenu "$@" -l 4 -i -p "Action:")

vpn_disable() {
  active_vpns=$(nmcli -t -f NAME,TYPE con show --active | awk -F: '$2 == "wireguard" {print $1}')
  [ -z "$active_vpns" ] && notify-send "VPN" "No active VPN connections" && exit
  while read -r vpn; do
    [ -n "$vpn" ] && nmcli con down "$vpn"
  done <<< "$active_vpns"
  notify-send -u critical "VPN" "All VPNs disabled"
}

vpn_enable() {
  vpns=$(nmcli -t -f NAME,TYPE con show | awk -F: '$2 == "wireguard" {print $1}')
  [ -z "$vpns" ] && notify-send "VPN" "No VPN connections configured" && exit
  vpn=$(echo "$vpns" | dmenu "$@" -l 5 -i -p "Enable VPN:")
  [ -z "$vpn" ] && exit
  active_vpns=$(nmcli -t -f NAME,TYPE con show --active | awk -F: '$2 == "wireguard" {print $1}')
  while read -r ovpn; do
    [ -n "$ovpn" ] && nmcli con down "$ovpn"
  done <<< "$active_vpns"
  notify-send -u critical "VPN" "Enabled <b>$vpn</b>"
  nmcli con up "$vpn"
}



disconnect() {
  while read -r line; do
    if [ "$line" == "NAME" ]; then continue; fi
    TYPE=$(nmcli -t con show "$line" | grep connection.type | cut -d ':' -f 2)
    if [[ "$TYPE" == *"wireles"* ]]; then
      notify-send -u critical "WiFi" "Disabled <b>$line</b>"
      nmcli con down "$line"
      exit
    fi
  done <<< $(nmcli -f NAME con show --active)
} 

connect() {
  ssids=""
  while read -r line; do
    if [ "$line" == "--" ] || [ "$line" == "SSID" ]; then
      continue
    fi
    if [[ -z "$ssids" ]]; then
      ssids="${line}"
    elif [[ "$ssids" != *"$line"* ]]; then
      ssids="${ssids} \n ${line}"
    fi
  done <<< $(nmcli -f SSID dev wifi list)

  essid=$(echo -e $ssids | dmenu "$@" -l 5 -i -p "Select a WiFi Network:")

  existing_connections=$(nmcli -f NAME con show)

  if [[ "$existing_connections" == *"$essid"* ]]; then
    notify-send -u critical "WiFi" "Enabled <b>$essid</b>"
    nmcli con up $essid
    exit
  fi

  password=$(dmenu "$@" -p "WiFi Password:" <&- )
  notify-send -u critical "WiFi" "Enabled <b>$essid</b>"
  nmcli device wifi connect $essid password "$password"
}


case "$action" in
  "Disconnect from Network")
    disconnect "$@" ;;
  "Connect to Network")
    connect "$@" ;;
  "Enable VPN")
    vpn_enable "$@" ;;
  "Disable VPN")
    vpn_disable "$@" ;;
esac


