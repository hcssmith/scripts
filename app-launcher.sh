#!/bin/bash
browser=vivaldi
browser_flags=--force-device-scale-factor=2

menu=" Terminal\n Internet\n Media\n Development\n󱔘 Documentation\n System\n Mount USB\n Unmount USB\n󰀻 Run"

opt=$(echo -e "$menu" | dmenu "$@" -i -l 9 -p "Option")

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

mount_usb() {
	if findmnt /dev/sda &>/dev/null; then
		notify-send "USB Already Mounted"
		return
	fi

	res=$(udisksctl mount -b /dev/sda 2>&1 | awk -F ' ' '{print $4}')
	action=$(dunstify -a "app-launcher" "/dev/sda Mounted" "$res" -A open,"Open Terminal")

	if [ "$action" = "2" ]; then
		st -d "$res" &
	fi
}

unmount_usb() {
	if ! findmnt /dev/sda &>/dev/null; then
		notify-send "No USB mounted"
		return
	fi

	err=$(udisksctl unmount -b /dev/sda 2>&1)
	if echo "$err" | grep -qi "busy"; then
		notify-send "Unmount failed" "Device is in use"
		return
	fi

	notify-send "/dev/sda Unmounted"
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
" Mount USB")
	mount_usb
	;;
" Unmount USB")
	unmount_usb
	;;
esac
