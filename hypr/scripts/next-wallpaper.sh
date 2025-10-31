#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/WALLS"
CACHE_FILE="$HOME/.config/.current_wallpaper"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

# Get wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \) | sort)
TOTAL=${#WALLPAPERS[@]}

if [ $TOTAL -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Initialize cache if missing
if [ ! -f "$CACHE_FILE" ]; then
    echo 0 > "$CACHE_FILE"
fi

INDEX=$(cat "$CACHE_FILE")
NEXT=$(( (INDEX + 1) % TOTAL ))
echo "$NEXT" > "$CACHE_FILE"

CURRENT_WALL="${WALLPAPERS[$NEXT]}"

# Kill any running swaybg and set new wallpaper
pkill swaybg 2>/dev/null
swaybg -i "$CURRENT_WALL" -m fill &

# --- Update only the background path in Hyprlock ---
if [ -f "$HYPRLOCK_CONF" ]; then
    awk -v newpath="$CURRENT_WALL" '
    BEGIN { in_bg = 0 }
    /^background *\{/ { in_bg = 1 }
    in_bg && /^ *path *=/ { sub(/=.*/, "= " newpath) }
    in_bg && /^\}/ { in_bg = 0 }
    { print }
    ' "$HYPRLOCK_CONF" > "$HYPRLOCK_CONF.tmp" && mv "$HYPRLOCK_CONF.tmp" "$HYPRLOCK_CONF"
fi

