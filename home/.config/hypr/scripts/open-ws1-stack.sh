#!/bin/sh
set -eu

clients_json="$(hyprctl clients -j 2>/dev/null || printf '[]')"

has_client() {
  query="$1"
  printf '%s\n' "$clients_json" | jq -e "$query" >/dev/null 2>&1
}

hyprctl dispatch workspace 1

if ! has_client '.[] | select(.workspace.id == 1 and .class == "firefox")'; then
  hyprctl dispatch exec "[workspace 1 silent] firefox"
fi

if ! has_client '.[] | select(.workspace.id == 1 and (.class == "cursor" or .class == "Cursor"))'; then
  hyprctl dispatch exec "[workspace 1 silent] cursor"
fi

if ! has_client '.[] | select(.workspace.id == 1 and .class == "ws1-kitty")'; then
  hyprctl dispatch exec "[workspace 1 silent] kitty --class ws1-kitty --title ws1-kitty"
fi
