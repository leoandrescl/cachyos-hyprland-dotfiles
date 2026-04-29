#!/bin/sh
set -eu

wstyle="$HOME/.config/wofi/network.css"
choice="$(printf '%s\n' "Suspend now" "Cancel" | wofi --dmenu --prompt "Confirm suspend" --style "$wstyle" || true)"

if [ "${choice:-}" = "Suspend now" ]; then
  systemctl suspend --check-inhibitors=no
fi
