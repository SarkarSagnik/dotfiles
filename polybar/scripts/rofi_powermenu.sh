#!/bin/bash

chosen=$(echo -e " Lock\n⏻ Power Off\n Reboot\n Suspend\n Logout" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
    " Lock")  betterlockscreen -l;;
    "⏻ Power Off") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Suspend") betterlockscreen -l;;
    " Logout") i3-msg exit ;;
    *) exit 1 ;;
esac

