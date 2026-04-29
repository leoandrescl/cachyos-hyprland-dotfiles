#!/bin/sh
set -eu

mon_json="$(hyprctl monitors -j 2>/dev/null || printf '[]')"
clients_json="$(hyprctl clients -j 2>/dev/null || printf '[]')"

mx="$(printf '%s\n' "$mon_json" | jq -r '.[] | select(.name=="HDMI-A-1") | .x')"
my="$(printf '%s\n' "$mon_json" | jq -r '.[] | select(.name=="HDMI-A-1") | .y')"
mw="$(printf '%s\n' "$mon_json" | jq -r '.[] | select(.name=="HDMI-A-1") | .width')"
mh="$(printf '%s\n' "$mon_json" | jq -r '.[] | select(.name=="HDMI-A-1") | .height')"

[ -n "${mx:-}" ] && [ -n "${my:-}" ] && [ -n "${mw:-}" ] && [ -n "${mh:-}" ] || exit 0

half_w=$((mw / 2))
half_h=$((mh / 2))

place_query() {
  query="$1"
  px="$2"
  py="$3"

  addr="$(printf '%s\n' "$clients_json" | jq -r "$query | .address" | head -n 1)"
  [ -n "${addr:-}" ] && [ "$addr" != "null" ] || return 0

  hyprctl dispatch focuswindow "address:$addr" >/dev/null 2>&1 || true
  hyprctl dispatch movewindowpixel "exact $px $py,address:$addr" >/dev/null 2>&1 || true
  hyprctl dispatch resizewindowpixel "exact $half_w $half_h,address:$addr" >/dev/null 2>&1 || true
}

# Top-left, top-right, bottom-left, bottom-right
place_query '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-btop$"; "i")) or ((.title // "") | test("^ws6-btop$"; "i"))))' "$mx" "$my"
place_query '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-nvtop$"; "i")) or ((.title // "") | test("^ws6-nvtop$"; "i"))))' "$((mx + half_w))" "$my"
place_query '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-iftop$"; "i")) or ((.title // "") | test("^ws6-iftop$"; "i"))))' "$mx" "$((my + half_h))"
place_query '.[] | select(.workspace.id == 6 and (((.initialTitle // "") | test("^ws6-shell$"; "i")) or ((.title // "") | test("^ws6-shell$"; "i"))))' "$((mx + half_w))" "$((my + half_h))"
