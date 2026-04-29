#!/bin/sh
set -eu

# Clipboard history daemon (optional dependency).
if command -v wl-paste >/dev/null 2>&1 && command -v cliphist >/dev/null 2>&1; then
  pgrep -x wl-paste >/dev/null 2>&1 || wl-paste --type text --watch cliphist store >/dev/null 2>&1 &
fi

# Polkit agent is launched explicitly from hyprland.conf.
