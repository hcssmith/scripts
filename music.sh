#!/bin/sh

music_commands="Play\nPause\nStop\nShuffle\nNext\nPrev\nChange Music"

cmd=$(echo -e $music_commands | dmenu "$@" -i -l 5 -p "Action")

echo $cmd

select_music() {
  echo "New Music"
}

case "$cmd" in
"Play")
  mpc play
  ;;
"Pause")
  mpc pause
  ;;
"Stop")
  mpc stop
  ;;
"Shuffle")
  mpc shuffle
  ;;
"Next")
  mpc next
  ;;
"Prev")
  "mpc prev"
  ;;
"Change Music")
  select_music
  ;;
esac
