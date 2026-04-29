#!/bin/sh
set -eu

clients_json="$(hyprctl clients -j 2>/dev/null || printf '[]')"
net_if="$(ip route show default 2>/dev/null | awk 'NR==1{print $5}')"
[ -n "${net_if:-}" ] || net_if="enp5s0"

has_client() {
  query="$1"
  printf '%s\n' "$clients_json" | jq -e "$query" >/dev/null 2>&1
}

hyprctl dispatch workspace 6

if ! has_client '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-btop$"; "i")) or ((.title // "") | test("^ws6-btop$"; "i"))))'; then
  hyprctl dispatch exec "[workspace 6 silent] kitty --class ws6-btop --title ws6-btop sh -lc btop"
fi

if ! has_client '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-nvtop$"; "i")) or ((.title // "") | test("^ws6-nvtop$"; "i"))))'; then
  hyprctl dispatch exec "[workspace 6 silent] kitty --class ws6-nvtop --title ws6-nvtop sh -lc nvtop"
fi

if ! has_client '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-iftop$"; "i")) or ((.title // "") | test("^ws6-iftop$"; "i"))))'; then
  hyprctl dispatch exec "[workspace 6 silent] kitty --class ws6-iftop --title ws6-iftop sh -lc 'iftop -i $net_if'"
fi

if ! has_client '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-shell$"; "i")) or ((.title // "") | test("^ws6-shell$"; "i"))))'; then
  hyprctl dispatch exec "[workspace 6 silent] kitty --class ws6-shell --title ws6-shell"
fi

# Give new windows a moment to map before arranging.
sleep 0.25
"$HOME/.config/hypr/scripts/arrange-ws6-grid.sh"
sleep 0.35
"$HOME/.config/hypr/scripts/arrange-ws6-grid.sh"
