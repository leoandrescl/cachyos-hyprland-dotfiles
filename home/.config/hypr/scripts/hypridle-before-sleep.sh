#!/bin/sh
# hypridle runs this before `systemctl suspend`. Must exit 0 or suspend may be skipped.
set -eu

loginctl lock-session 2>/dev/null || true

if ! pgrep -x hyprlock >/dev/null 2>&1 && command -v hyprlock >/dev/null 2>&1; then
  hyprlock >/dev/null 2>&1 &
  sleep 0.35
fi

exit 0
