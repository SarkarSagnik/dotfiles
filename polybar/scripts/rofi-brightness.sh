#!/bin/bash

# Set environment (important for Polybar)
export DISPLAY=:0
export XAUTHORITY=/home/$USER/.Xauthority

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
MAX_FILE="/sys/class/backlight/intel_backlight/max_brightness"

# Read current values
current=$(cat "$BRIGHTNESS_FILE")
max=$(cat "$MAX_FILE")
percent=$((100 * current / max))

# Generate options
options=$(seq 10 10 100 | sed 's/$/%/')

# Show rofi menu
chosen=$(echo "$options" | rofi -dmenu -p "Brightness: $percent%" -theme-str 'window { width: 20ch; }' 2>/dev/null)

if [[ "$chosen" =~ ^[0-9]+%$ ]]; then
    new_percent=${chosen%\%}
    new_value=$((max * new_percent / 100))
    
    # Try direct write (will work after udev rules are applied)
    if echo "$new_value" > "$BRIGHTNESS_FILE"; then
        exit 0
    else
        # Fallback that always works
        dbus-send --session --type=method_call --dest=org.gnome.SettingsDaemon.Power /org/gnome/SettingsDaemon/Power org.gnome.SettingsDaemon.Power.Screen.SetPercentage uint32:$new_percent
    fi
fi
