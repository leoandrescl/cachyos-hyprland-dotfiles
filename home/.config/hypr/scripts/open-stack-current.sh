#!/bin/sh
set -eu

stack="${1:?stack id: 1 (firefox stack) | 2 (chrome stack)}"

case "$stack" in
  1)
    hyprctl dispatch exec "firefox --new-window" >/dev/null 2>&1 || true
    hyprctl dispatch exec "cursor --new-window" >/dev/null 2>&1 || true
    hyprctl dispatch exec "kitty --class ws1-kitty --title ws1-kitty" >/dev/null 2>&1 || true
    ;;
  2)
    hyprctl dispatch exec "google-chrome-stable --new-window" >/dev/null 2>&1 || true
    hyprctl dispatch exec "cursor --new-window" >/dev/null 2>&1 || true
    hyprctl dispatch exec "kitty --class ws2-kitty --title ws2-kitty" >/dev/null 2>&1 || true
    ;;
  *)
    printf 'open-stack-current.sh: unknown stack %s\n' "$stack" >&2
    exit 2
    ;;
esac
