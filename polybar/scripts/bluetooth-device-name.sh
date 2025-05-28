#!/bin/bash

# Get MAC address of the first connected Bluetooth device
device_mac=$(bluetoothctl info | awk '/Device/ {print $2; exit}')

# If a device is connected
if [[ -n "$device_mac" ]]; then
    # Get the device name
    device_name=$(bluetoothctl info "$device_mac" | awk -F ': ' '/Name/ {print $2; exit}')
    echo " $device_name"
else
    echo " No Device"
fi

