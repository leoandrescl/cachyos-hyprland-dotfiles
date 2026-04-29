#!/bin/sh
set -eu

clients_json="$(hyprctl clients -j 2>/dev/null || printf '[]')"

has_client() {
  query="$1"
  printf '%s\n' "$clients_json" | jq -e "$query" >/dev/null 2>&1
}

hyprctl dispatch workspace 2

if ! has_client '.[] | select(.workspace.id == 2 and (.class | test("^(Google-chrome|google-chrome|Google-chrome-stable|google-chrome-stable|Chromium|chromium)$")))' ; then
  hyprctl dispatch exec "[workspace 2 silent] google-chrome-stable"
fi

if ! has_client '.[] | select(.workspace.id == 2 and (.class == "cursor" or .class == "Cursor"))' ; then
  hyprctl dispatch exec "[workspace 2 silent] cursor"
fi

if ! has_client '.[] | select(.workspace.id == 2 and .class == "ws2-kitty")'; then
  hyprctl dispatch exec "[workspace 2 silent] kitty --class ws2-kitty --title ws2-kitty"
fi
