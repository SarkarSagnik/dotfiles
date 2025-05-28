#!/bin/bash

# Extract SSIDs only (column 1), remove duplicates, and show in rofi
ssid=$(nmcli -t -f SSID device wifi list | grep -v '^$' | awk '!seen[$0]++' | rofi -dmenu -p "Connect to WiFi:")

if [ -n "$ssid" ]; then
    # Ask for password
    passwd=$(rofi -dmenu -password -p "Password for $ssid:")

    # Attempt to connect
    if [ -n "$passwd" ]; then
        nmcli device wifi connect "$ssid" password "$passwd"
    else
        nmcli device wifi connect "$ssid"
    fi
fi

