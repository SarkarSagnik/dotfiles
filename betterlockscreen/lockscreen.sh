#!/bin/bash

BG_PATH="$HOME/.config/backgrounds/shaded.jpg"
# AVATAR_PATH="$HOME/.face"
LOCK_BG="$HOME/.cache/lockscreen.png"

# Blur the background and dim it
convert "$BG_PATH" -blur 0x8 -fill 'rgba(0,0,0,0.4)' -colorize 50% "$LOCK_BG"

# Add date and time (fixed at lock time)
DATE_STR=$(date +"%A, %d %B %Y")
TIME_STR=$(date +"%R")

# Add time
#convert "$LOCK_BG" -gravity northeast -pointsize 90 -font "JetBrainsMono Nerd Font Bold" -fill "#FFFFFF" -annotate +30+100 "$TIME_STR" "$LOCK_BG"

# Add date below time (spaced properly)
#convert "$LOCK_BG" -gravity northeast -pointsize 25 -font "JetBrainsMono Nerd Font Bold" -fill "#FFFFFF" -annotate +30+210 "$DATE_STR" "$LOCK_BG"

# Add avatar in center
# convert "$LOCK_BG" \( "$AVATAR_PATH" -resize 100x100 -bordercolor "#FFFFFF" -border 5 \) -gravity center -composite "$LOCK_BG"

