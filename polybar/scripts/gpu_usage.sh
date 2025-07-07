#!/bin/bash

# Get GPU utilization using nvidia-smi or radeontop
gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || radeontop -d - -l 1 | awk -F'[:,%]' '/gpu/ {gsub(/ /, "", $2); print $2}')

# Check if gpu_usage is empty or contains "Error"
if [[ -z "$gpu_usage" || "$gpu_usage" == *"Error"* ]]; then
  gpu_usage="Error"
fi

# Output the logo and usage percentage
printf " %s%%\n" "$gpu_usage"
