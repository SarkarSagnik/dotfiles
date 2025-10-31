#!/usr/bin/env bash
# Volume notification with native Dunst progress bar and volume on same line

get_volume() {
    pamixer --get-volume
}

get_mute() {
    pamixer --get-mute
}

case "$1" in
    up) pamixer -i 5 ;;
    down) pamixer -d 5 ;;
    mute) pamixer -t ;;
esac

vol=$(get_volume)
muted=$(get_mute)

if [ "$muted" = "true" ]; then
    text="Volume Muted"
    value=0
else
    text="Volume ${vol}%"
    value=$vol
fi

dunstify -a "Volume" -r 2593 -u low "$text" \
    -h int:value:"$value" \
    -h string:markup:1 \
    -h string:x-dunst-stack-tag:volume

