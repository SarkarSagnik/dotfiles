#!/bin/bash

# Dependencies: bluetoothctl, rofi, awk, grep, notify-send, pactl

theme='window {width: 30%;}'

# Scan for new devices in background (non-blocking)
bluetoothctl scan on & disown

# Gather paired devices (MAC + Name)
paired_devices=$(bluetoothctl devices | awk '{print $2 " " substr($0, index($0,$3))}')

# Option to pair new devices
menu_list="🔍 Pair new device\n$paired_devices"

# Show menu in Rofi
chosen=$(echo -e "$menu_list" | rofi -dmenu -p "Bluetooth devices" -theme-str "$theme")

[ -z "$chosen" ] && exit 0

# If user chooses to pair new device
if [[ "$chosen" == "🔍 Pair new device" ]]; then
  # Scan for new devices (foreground for 5 sec)
  notify-send "Bluetooth" "Scanning for devices..."
  bluetoothctl scan on > /dev/null &
  sleep 5
  bluetoothctl scan off

  # Get list of unpaired, visible devices
  available_devices=$(bluetoothctl devices | grep -v -f <(bluetoothctl paired-devices | awk '{print $2}') | awk '{print $2 " " substr($0, index($0,$3))}')

  if [ -z "$available_devices" ]; then
    notify-send "Bluetooth" "No new devices found."
    exit 1
  fi

  # Prompt to select new device to pair
  new_device=$(echo "$available_devices" | rofi -dmenu -p "Pair with device" -theme-str "$theme")
  [ -z "$new_device" ] && exit 0

  mac=$(echo "$new_device" | awk '{print $1}')
  name=$(echo "$new_device" | cut -d ' ' -f2-)

  bluetoothctl pair "$mac" && bluetoothctl trust "$mac" && bluetoothctl connect "$mac"

  # Wait for device to register as sink
  sleep 3

  # Attempt to switch audio sink
  sink=$(pactl list short sinks | grep -i "$mac" | awk '{print $2}')
  [ -z "$sink" ] && sink=$(pactl list short sinks | grep -i bluez | awk '{print $2}')
  if [ -n "$sink" ]; then
    pactl set-default-sink "$sink"
    for input in $(pactl list short sink-inputs | awk '{print $1}'); do
      pactl move-sink-input "$input" "$sink"
    done
    notify-send "Bluetooth" "Paired and audio routed to $name"
  else
    notify-send "Bluetooth" "Paired, but no audio sink found."
  fi

  exit 0
fi

# Else — user picked a paired device
mac=$(echo "$chosen" | awk '{print $1}')
name=$(echo "$chosen" | cut -d ' ' -f2-)

connected=$(bluetoothctl info "$mac" | grep -q "Connected: yes" && echo "yes" || echo "no")

if [ "$connected" == "yes" ]; then
  bluetoothctl disconnect "$mac" && notify-send "Bluetooth" "Disconnected from $name"
else
  bluetoothctl connect "$mac" && notify-send "Bluetooth" "Connected to $name"
  sleep 3

  # Try to find and switch to audio sink
  sink=$(pactl list short sinks | grep -i "$mac" | awk '{print $2}')
  [ -z "$sink" ] && sink=$(pactl list short sinks | grep -i bluez | awk '{print $2}')
  if [ -n "$sink" ]; then
    pactl set-default-sink "$sink"
    for input in $(pactl list short sink-inputs | awk '{print $1}'); do
      pactl move-sink-input "$input" "$sink"
    done
    notify-send "Audio Output" "Switched to $name"
  else
    notify-send "Audio Output" "Connected, but no audio sink found."
  fi
fi

