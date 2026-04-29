#!/bin/sh
set -eu

notify-send "System mode (3s)" "Q: Exit  L: Lock  S: Suspend  R: Reboot  P: Poweroff  Esc: Cancel"
hyprctl dispatch submap system
(sleep 3; hyprctl dispatch submap reset) >/dev/null 2>&1 &
