#!/bin/sh
set -eu

pkill -x waybar || true
sleep 0.4
nohup waybar -c "$HOME/.config/waybar/config" -s "$HOME/.config/waybar/style.css" >>/tmp/waybar.log 2>&1 &
