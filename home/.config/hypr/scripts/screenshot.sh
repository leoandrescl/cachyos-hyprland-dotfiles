#!/bin/sh
set -eu

mode="${1:-area-copy}"
out_dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
ts="$(date +%Y-%m-%d_%H-%M-%S)"
file="$out_dir/$ts.png"
wstyle="$HOME/.config/wofi/network.css"

mkdir -p "$out_dir"

case "$mode" in
  interactive)
    geometry="$(slurp)" || exit 0
    [ -n "${geometry:-}" ] || exit 0

    grim -g "$geometry" "$file"
    wl-copy < "$file"
    notify-send "Screenshot" "Saved and copied to clipboard"

    action="$(printf '%s\n' \
      "Copy image again" \
      "Copy file path" \
      "Open screenshots folder" \
      "Open image" \
      "Take another screenshot" \
      | wofi --dmenu --prompt "Screenshot actions" --style "$wstyle" || true)"

    case "${action:-}" in
      "Copy image again")
        wl-copy < "$file"
        notify-send "Screenshot" "Image copied to clipboard"
        ;;
      "Copy file path")
        printf '%s' "$file" | wl-copy
        notify-send "Screenshot" "File path copied"
        ;;
      "Open screenshots folder")
        if command -v dolphin >/dev/null 2>&1; then
          dolphin "$out_dir" >/dev/null 2>&1 &
        elif command -v xdg-open >/dev/null 2>&1; then
          xdg-open "$out_dir" >/dev/null 2>&1 &
        fi
        ;;
      "Open image")
        if command -v xdg-open >/dev/null 2>&1; then
          xdg-open "$file" >/dev/null 2>&1 &
        fi
        ;;
      "Take another screenshot")
        exec "$0" interactive
        ;;
      *)
        :
        ;;
    esac
    ;;
  area-copy)
    grim -g "$(slurp)" - | wl-copy
    ;;
  area-save)
    grim -g "$(slurp)" "$file"
    notify-send "Screenshot" "Saved area screenshot to $file"
    ;;
  full-save)
    grim "$file"
    notify-send "Screenshot" "Saved full screenshot to $file"
    ;;
  *)
    echo "Usage: screenshot.sh {interactive|area-copy|area-save|full-save}" >&2
    exit 1
    ;;
esac
