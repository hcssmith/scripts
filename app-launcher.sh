#!/bin/bash
browser=vivaldi
browser_flags=--force-device-scale-factor=2

menu=" Terminal\n Internet\n Media\n Development\n󱔘 Documentation\n System\n󰀻 Run"

opt=$(echo -e "$menu" | dmenu "$@" -i -l 7 -p "Option")

search_cmd() {
  stext=$(dmenu "$@" -p " Search For:" <&-)
  $browser $browser_flags "https://www.google.com/search?q=$stext" &
}

internet_menu() {
  menu="󰖟 Browser\n󰭹 ChatGPT\n󰇮 Email\n Search\n󰣳 NAS"
  opt=$(echo -e "$menu" | dmenu "$@" -i -l 5 -p " Internet")
  case $opt in
  "󰖟 Browser")
    $browser $browser_flags &
    ;;
  "󰭹 ChatGPT")
    $browser $browser_flags --app=https://chatgpt.com &
    ;;
  "󰇮 Email")
    $browser $browser_flags "https://fastmail.com/"
    xdotool key --clearmodifiers Super+1 &
    ;;
  " Search")
    search_cmd "$@"
    xdotool key --clearmodifiers Super+1
    ;;
  "󰣳 NAS")
    $browser $browser_flags --app=http://fritz.box &
    xdotool key --clearmodifiers Super+1 
    ;;
  esac
}

manpage() {
  page=$(man -k . | awk -F ' ' '{print $1,$2}' | dmenu "$@" -i -l 5 -p "󰙃 Select Manpage:" | awk -F ' ' '{print "man", $2, $1}' | tr -d '()')
  if [[ -z "$page" ]]; then exit; fi
  st -c manpages "$page" &
}

docs_menu() {
  menu="󰙃 Manpages\n󰅩 Odin Standard Library"
  opt=$(echo -e "$menu" | dmenu "$@" -i -l 5 -p "󱔘 Documentation:")
  case $opt in
  "󰙃 Manpages")
    manpage "$@"
    ;;
  "󰅩 Odin Standard Library")
    $browser $browser_flags "https://pkg.odin-lang.org/" &
    xdotool key --clearmodifiers Super+1
    ;;
  esac
}

case $opt in
" Terminal")
  st &
  ;;
" Internet")
  internet_menu "$@"
  ;;
" Media")
  music.sh "$@"
  ;;
" Development")
  src-projects.sh "$@"
  ;;
"󱔘 Documentation")
  docs_menu "$@"
  ;;
" System")
  system.sh "$@"
  ;;
"󰀻 Run")
  dmenu_run "$@"
  ;;
esac
