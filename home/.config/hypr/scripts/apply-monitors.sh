#!/bin/sh
set -eu

sleep 2
hyprctl keyword monitor "DP-2,5120x1440@240.00,0x0,1,bitdepth,10"
hyprctl keyword monitor "HDMI-A-1,3840x2160@60,5120x0,1"
