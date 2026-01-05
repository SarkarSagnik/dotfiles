#!/usr/bin/env bash

# Check if the powerprofilesctl utility exists
if ! command -v powerprofilesctl &> /dev/null
then
    echo "Error: 'powerprofilesctl' command not found. Install power-profiles-daemon."
    exit 1
fi

# Get the profile argument
PROFILE="$1"

if [ -z "$PROFILE" ]; then
    echo "Usage: $0 <profile_name>"
    exit 1
fi

# Set the new power profile
powerprofilesctl set "$PROFILE"

# Optional: Send a notification that the profile has changed
if command -v notify-send &> /dev/null
then
    notify-send "Power Profile Switched" "Profile set to: $PROFILE" -t 3000
fi

echo "Power profile set to: $PROFILE"
