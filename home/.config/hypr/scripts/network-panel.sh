#!/bin/sh
set -eu

wstyle="$HOME/.config/wofi/network.css"
tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

wifi_state="$(nmcli radio wifi 2>/dev/null || echo unknown)"
active_wifi="$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2 " (" $3 "%)"; exit}')"
active_connections="$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null)"
default_route="$(ip route show default 2>/dev/null | awk 'NR==1{print $3 " via " $5}')"
ip4_info="$(nmcli -t -f DEVICE,IP4.ADDRESS dev show 2>/dev/null | awk -F: 'NF>=2 && $2 != "" {print $1 ": " $2}')"
dns_info="$(nmcli -t -f IP4.DNS dev show 2>/dev/null | awk -F: '$2 != "" {print $2}' | awk '!seen[$0]++')"

{
  echo "Network status"
  echo "-----"
  echo "Wi-Fi radio: $wifi_state"
  if [ -n "${active_wifi:-}" ]; then
    echo "Active Wi-Fi: $active_wifi"
  else
    echo "Active Wi-Fi: none"
  fi
  echo "Default route: ${default_route:-none}"
  echo "-----"
  echo "Active connections"
  if [ -n "${active_connections:-}" ]; then
    printf '%s\n' "$active_connections" | sed 's/:/ · /'
  else
    echo "No active connections"
  fi
  echo "-----"
  echo "IPv4 addresses"
  if [ -n "${ip4_info:-}" ]; then
    printf '%s\n' "$ip4_info"
  else
    echo "No IPv4 addresses"
  fi
  echo "-----"
  echo "DNS servers"
  if [ -n "${dns_info:-}" ]; then
    printf '%s\n' "$dns_info"
  else
    echo "No DNS data"
  fi
  echo "-----"
  echo "Open connection menu"
  echo "Refresh status"
} > "$tmp_file"

choice="$(wofi --dmenu --prompt "Network Info" --style "$wstyle" < "$tmp_file" || true)"
[ -n "${choice:-}" ] || exit 0

case "$choice" in
  "Open connection menu")
    exec "$HOME/.config/hypr/scripts/network-menu.sh"
    ;;
  "Refresh status")
    exec "$HOME/.config/hypr/scripts/network-panel.sh"
    ;;
  *)
    exit 0
    ;;
esac
