#!/bin/sh
set -eu

action="${1:-}"
hyprctl dispatch submap reset

case "$action" in
  lock)
    pidof hyprlock >/dev/null || hyprlock
    ;;
  suspend)
    "$HOME/.config/hypr/scripts/confirm-suspend.sh"
    ;;
  reboot)
    systemctl reboot
    ;;
  poweroff)
    systemctl poweroff
    ;;
  exit)
    hyprctl dispatch exit
    ;;
  *)
    exit 1
    ;;
esac
