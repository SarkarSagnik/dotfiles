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

if [ "$percent" -le 33 ]; then
    icon="󰃞"
elif [ "$percent" -le 66 ]; then
    icon="󰃟"
else
    icon="󰃠"
fi

text="$icon ${percent}%"

dunstify -a "Brightness" -r 2594 -u low "$text" \
    -h int:value:"$percent" \
    -h string:x-dunst-stack-tag:brightness

