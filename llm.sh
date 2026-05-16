if ps aux | grep -q '[A]nythingLLMDesk'; then
  notify-send "AnythingLLM" "Already running"
else
  ~/Apps/AnythingLLMDesktop.AppImage --force-device-scale-factor=2 &
fi
