#!/bin/bash

chosen=$(echo -e "⏻ Power Off\n Reboot\n Lock\n Suspend\n Cancel" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
  "⏻ Power Off") systemctl poweroff ;;
  " Reboot") systemctl reboot ;;
  " Lock") swaylock ;;
  " Suspend") systemctl suspend ;;
  *) exit 0 ;;
esac
