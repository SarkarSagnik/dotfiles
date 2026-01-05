#!/usr/bin/env bash

PROFILE_SETTER="$HOME/.config/hypr/scripts/set_power_profile.sh"
# Define the exact profiles we want to show
DESIRED_PROFILES="performance\nbalanced\npower-saver"

# 1. Get the current active profile (e.g., "  * balanced")
# We use sed to extract just the name (e.g., 'balanced')
CURRENT_PROFILE=$(powerprofilesctl list | grep '*' | sed 's/.*\* //')

# 2. Use Rofi to list only the desired profiles
# The DESIRED_PROFILES variable provides the input list directly
SELECTED_PROFILE=$(echo -e "$DESIRED_PROFILES" | rofi -dmenu \
    -p "Power Profile (Current: $CURRENT_PROFILE)" \
    -theme-str 'listview{columns:1;}' \
    -i)

if [ -n "$SELECTED_PROFILE" ]; then
    # 3. Run the master script with the selected profile
    # The selected profile must be one of the three defined above
    "$PROFILE_SETTER" "$SELECTED_PROFILE" &
fi
