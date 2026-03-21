#!/usr/bin/env bash

choice=$(printf "⏻ Shutdown\n󰜉 Restart" | wofi --dmenu --prompt "Power" --width 260 --height 160 --insensitive)

case "$choice" in
  "⏻ Shutdown")
    systemctl poweroff
    ;;
  "󰜉 Restart")
    systemctl reboot
    ;;
esac
