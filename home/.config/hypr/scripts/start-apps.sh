#!/bin/sh
set -eu

# Give Hyprland a moment to finish initial workspace/monitor mapping.
sleep 3

# WS1: Firefox + Cursor + kitty (Agents UI if Cursor opens that mode by default)
hyprctl dispatch exec "[workspace 1 silent] firefox"
hyprctl dispatch exec "[workspace 1 silent] cursor"
hyprctl dispatch exec "[workspace 1 silent] kitty --class ws1-kitty --title ws1-kitty"

# WS2: Chrome + Cursor + kitty
hyprctl dispatch exec "[workspace 2 silent] google-chrome-stable"
sleep 0.4
hyprctl dispatch exec "[workspace 2 silent] cursor"
hyprctl dispatch exec "[workspace 2 silent] kitty --class ws2-kitty --title ws2-kitty"

# Secondary monitor / workspace 6
"$HOME/.config/hypr/scripts/open-ws6-monitoring.sh"
