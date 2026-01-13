#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/.config/WALLS"
if ! command -v swww &> /dev/null; then echo "swww not found"; exit 1; fi
if ! command -v find &> /dev/null; then echo "find not found"; exit 1; fi
NOTIFY=false
if command -v notify-send &> /dev/null; then NOTIFY=true; fi
CACHE_FILE="$HOME/.config/niri/.current_wallpaper"

# Get wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \) | sort)
TOTAL=${#WALLPAPERS[@]}

if [ $TOTAL -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Initialize cache if missing
if [ ! -f "$CACHE_FILE" ]; then
    echo 1 > "$CACHE_FILE"
fi

INDEX=$(cat "$CACHE_FILE")
PREV_WALL="${WALLPAPERS[$INDEX]}"
NEXT=$(( (INDEX + 1) % TOTAL ))
echo "$NEXT" > "$CACHE_FILE"

CURRENT_WALL="${WALLPAPERS[$NEXT]}"

# Set new wallpaper with swww
swww img "$CURRENT_WALL" --resize crop --transition-duration 0.5 --transition-type fade
if $NOTIFY; then notify-send "Wallpaper Changed" "Set to $(basename "$CURRENT_WALL")"; fi

# Create symlink to current wallpaper for niri
CURRENT_WALL_LINK="$HOME/.config/niri/current_wallpaper"
ln -sf "$CURRENT_WALL" "$CURRENT_WALL_LINK"

# ------------------------------------------------------------------
# --- Update 1: Background image in Gtklock ---
# ------------------------------------------------------------------
GTKLOCK_CONF="$HOME/.config/gtklock/config.ini"
if [ -f "$GTKLOCK_CONF" ]; then
    sed -i "s|^background=.*|background=$CURRENT_WALL|" "$GTKLOCK_CONF"
else
    echo "Warning: GTKLOCK_CONF not found at $GTKLOCK_CONF"
fi

