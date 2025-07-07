#!/bin/bash

# ===== Config =====
TEMP_FILE="/tmp/.redshift_temp"
STATE_FILE="/tmp/.redshift_state"
DEFAULT_TEMP=4000
TEMP_STEP=500
MIN_TEMP=3000
MAX_TEMP=6500

# ===== Initialize State =====
[[ -f "$TEMP_FILE" ]] || echo "$DEFAULT_TEMP" > "$TEMP_FILE"
[[ -f "$STATE_FILE" ]] || echo "off" > "$STATE_FILE"

TEMP=$(<"$TEMP_FILE")
STATE=$(<"$STATE_FILE")

# ===== Rofi Menu with Intuitive Labels =====
CHOICE=$(printf "󰖔 Toggle Redshift (%s)\n Cooler (Bluer)\n Warmer (Redder)\n Reset Color" "$STATE" | rofi -dmenu -p "Redshift Control")

# ===== Functions =====
apply_redshift() {
    redshift -x
    sleep 0.2  # brief delay to let reset apply
    redshift -O "$TEMP"
    notify-send "Redshift ON" "Color Temp: ${TEMP}K"
}

reset_redshift() {
    redshift -x
    notify-send "Redshift OFF" "Color reset to default"
}

# ===== Action Handling =====
case "$CHOICE" in
    *Toggle*)
        if [[ "$STATE" == "on" ]]; then
            reset_redshift
            echo "off" > "$STATE_FILE"
        else
            apply_redshift
            echo "on" > "$STATE_FILE"
        fi
        ;;
    *Cooler*)
        NEW_TEMP=$((TEMP + TEMP_STEP))
        (( NEW_TEMP > MAX_TEMP )) && NEW_TEMP=$MAX_TEMP
        echo "$NEW_TEMP" > "$TEMP_FILE"
        TEMP="$NEW_TEMP"
        apply_redshift
        echo "on" > "$STATE_FILE"
        ;;
    *Warmer*)
        NEW_TEMP=$((TEMP - TEMP_STEP))
        (( NEW_TEMP < MIN_TEMP )) && NEW_TEMP=$MIN_TEMP
        echo "$NEW_TEMP" > "$TEMP_FILE"
        TEMP="$NEW_TEMP"
        apply_redshift
        echo "on" > "$STATE_FILE"
        ;;
    *Reset*)
        reset_redshift
        echo "$DEFAULT_TEMP" > "$TEMP_FILE"
        echo "off" > "$STATE_FILE"
        ;;
esac
