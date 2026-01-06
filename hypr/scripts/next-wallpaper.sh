#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/.config/WALLS"
if ! command -v swww &> /dev/null; then echo "swww not found"; exit 1; fi
if ! command -v find &> /dev/null; then echo "find not found"; exit 1; fi
NOTIFY=false
if command -v notify-send &> /dev/null; then NOTIFY=true; fi
CACHE_FILE="$HOME/.config/.current_wallpaper"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"
# --- NEW: Define the path to your Rofi theme/config ---
ROFI_CONF="$HOME/.config/rofi/theme.rasi" # ADJUST THIS PATH if your Rofi theme file is different!

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
PREV_WALL="${WALLPAPERS[$INDEX]}"
NEXT=$(( (INDEX + 1) % TOTAL ))
echo "$NEXT" > "$CACHE_FILE"

CURRENT_WALL="${WALLPAPERS[$NEXT]}"

# Set new wallpaper with swww
swww img "$CURRENT_WALL" --resize crop --transition-duration 0.5 --transition-type fade
if $NOTIFY; then notify-send "Wallpaper Changed" "Set to $(basename "$CURRENT_WALL")"; fi

# ------------------------------------------------------------------
# --- Update 1: Background path in Hyprlock ---
# ------------------------------------------------------------------
if [ -f "$HYPRLOCK_CONF" ]; then
    awk -v newpath="$CURRENT_WALL" '
    BEGIN { in_bg = 0 }
    /^background *\{/ { in_bg = 1 }
    in_bg && /^ *path *=/ { sub(/=.*/, "= " newpath) }
    in_bg && /^\}/ { in_bg = 0 }
    { print }
     ' "$HYPRLOCK_CONF" > "$HYPRLOCK_CONF.tmp" && mv "$HYPRLOCK_CONF.tmp" "$HYPRLOCK_CONF"
else
    echo "Warning: HYPRLOCK_CONF not found at $HYPRLOCK_CONF"
fi


# ------------------------------------------------------------------
# --- Update 2: Background image URL in Rofi theme ---
# ------------------------------------------------------------------
if [ -f "$ROFI_CONF" ]; then
    # We need to escape the path for use in the Rofi URL string
    ESCAPED_WALLPAPER_PATH="url(\"$(echo "$CURRENT_WALL" | sed 's/[\/&]/\\&/g')\");"
    
    awk -v newurl="$ESCAPED_WALLPAPER_PATH" '
    BEGIN { in_imagebox = 0 }
    
    # Start of the imagebox block
    /^imagebox *\{/ { in_imagebox = 1 }
    
    # Inside the imagebox block, find and replace the background-image line
    in_imagebox && /background-image: *url\(.*/ { 
        # Replace the entire line with the new path
        print "  background-image: " newurl
        next
    }
    
    # End of the imagebox block
    in_imagebox && /^\}/ { in_imagebox = 0 }
    
    # Print all other lines
    { print }
    ' "$ROFI_CONF" > "$ROFI_CONF.tmp" && mv "$ROFI_CONF.tmp" "$ROFI_CONF"
else
    echo "Warning: ROFI_CONF not found at $ROFI_CONF"
fi
