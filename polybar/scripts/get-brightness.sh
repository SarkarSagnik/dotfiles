#!/bin/bash
# Fetch brightness percentage and display icon + value
percent=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%\))')
echo " ${percent}%"

