#!/bin/bash
# Wrapper script to ensure proper environment when called from Polybar

export DISPLAY=:0
export XAUTHORITY=/home/$USER/.Xauthority

# Wait for rofi to close before continuing (important for Polybar)
~/.config/polybar/scripts/rofi-brightness.sh
