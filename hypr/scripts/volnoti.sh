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
    icon="󰝟"
    text="Muted"
    value=0
elif [ "$vol" -le 33 ]; then
    icon="󰕿"
    text="${vol}%"
    value=$vol
elif [ "$vol" -le 66 ]; then
    icon="󰖀"
    text="${vol}%"
    value=$vol
else
    icon="󰕾"
    text="${vol}%"
    value=$vol
fi

dunstify -a "Volume" -r 2593 -u low "$icon $text" \
    -h int:value:"$value" \
    -h string:x-dunst-stack-tag:volume

