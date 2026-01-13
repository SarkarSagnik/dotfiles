#!/usr/bin/env bash
set -euo pipefail

# Dependencies: wofi, gtklock, systemctl/loginctl
if ! command -v wofi &> /dev/null; then echo "wofi not found"; exit 1; fi
if ! command -v gtklock &> /dev/null; then echo "gtklock not found"; exit 1; fi
if ! command -v systemctl &> /dev/null && ! command -v loginctl &> /dev/null; then echo "systemctl or loginctl not found"; exit 1; fi

# Options with icons (using Nerd Fonts or similar)
options=" Lock\n󰗽 Logout\n Suspend\n󰤄 Hibernate\n Reboot\n Shutdown\n🌙 Night Light Toggle"

# Use wofi for selection
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Niri Power Menu" --width 500 --height 400 --style ~/.config/wofi/style.css)

case $chosen in
    " Lock")
        gtklock
        ;;
    "󰗽 Logout")
        niri msg action quit
        ;;
    " Suspend")
        systemctl suspend || loginctl suspend
        ;;
    "󰤄 Hibernate")
        systemctl hibernate || loginctl hibernate
        ;;
    " Reboot")
        systemctl reboot || loginctl reboot
        ;;
    " Shutdown")
        systemctl poweroff || loginctl poweroff
        ;;
    "🌙 Night Light Toggle")
        if pgrep -x "sunsetr" > /dev/null; then
            sunsetr stop
            notify-send "Night Light" "Disabled"
        else
            sunsetr --background
            notify-send "Night Light" "Enabled"
        fi
        ;;
    *)
        exit 1
        ;;
esac
