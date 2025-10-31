#!/usr/bin/env bash

# Dependencies: brightnessctl, dunstify

case "$1" in
    up)
        brightnessctl set +5% ;;
    down)
        brightnessctl set 5%- ;;
esac

brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$(( 100 * brightness / max_brightness ))



text="${icon} Brightness: ${percent}%"

dunstify -a "Brightness" -r 2594 -u low "$text" \
    -h int:value:"$percent" \
    -h string:markup:1 \
    -h string:x-dunst-stack-tag:brightness

