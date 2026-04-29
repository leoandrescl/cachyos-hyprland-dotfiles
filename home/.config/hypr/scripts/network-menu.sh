#!/bin/sh
set -eu

wstyle="$HOME/.config/wofi/network.css"
tmp_file="$(mktemp)"
meta_file="$(mktemp)"
trap 'rm -f "$tmp_file" "$meta_file"' EXIT

current_wifi="$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')"
current_conn="$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | head -n 1)"
wifi_state="$(nmcli radio wifi 2>/dev/null || echo unknown)"

{
  echo "Toggle Wi-Fi"
  echo "Rescan networks"
  echo "Refresh network list"
  echo ""

  if [ -n "${current_wifi:-}" ]; then
    echo "Connected now: ${current_wifi}"
  fi

  if [ -n "${current_conn:-}" ]; then
    echo "Active connection: ${current_conn}"
  fi

  echo "Radio: ${wifi_state}"
  echo ""
  echo "Available networks"
} > "$tmp_file"

nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null \
  | awk -F: '
      {
        connected = ($1 == "*") ? "yes" : "no"
        ssid = ($2 == "") ? "<hidden>" : $2
        signal = ($3 == "") ? "?" : $3
        security = ($4 == "") ? "Open" : $4
        marker = (connected == "yes") ? "Connected  " : "Wi-Fi       "
        display = marker ssid "  ·  " signal "%  ·  " security
        print display "\t" ssid "\t" security "\t" connected
      }
    ' \
  | awk -F'\t' '!seen[$1]++' > "$meta_file"

cut -f1 "$meta_file" >> "$tmp_file"

choice="$(wofi --dmenu --prompt "Network" --style "$wstyle" < "$tmp_file" || true)"
[ -n "${choice:-}" ] || exit 0

case "$choice" in
  "Toggle Wi-Fi")
    if [ "$wifi_state" = "enabled" ]; then
      nmcli radio wifi off
      notify-send "Network" "Wi-Fi disabled"
    else
      nmcli radio wifi on
      notify-send "Network" "Wi-Fi enabled"
    fi
    ;;
  "Rescan networks")
    nmcli dev wifi rescan
    notify-send "Network" "Wi-Fi scan started"
    ;;
  "Refresh network list")
    exec "$HOME/.config/hypr/scripts/network-menu.sh"
    ;;
  ""|"Available networks"|Connected\ now:*|Active\ connection:*|Radio:*)
    exit 0
    ;;
  *)
    record="$(awk -F'\t' -v selected="$choice" '$1 == selected { print; exit }' "$meta_file")"
    [ -n "${record:-}" ] || exit 0

    ssid="$(printf '%s\n' "$record" | awk -F'\t' '{print $2}')"
    security="$(printf '%s\n' "$record" | awk -F'\t' '{print $3}')"
    connected="$(printf '%s\n' "$record" | awk -F'\t' '{print $4}')"

    [ "$ssid" = "<hidden>" ] && exit 0
    [ "$connected" = "yes" ] && exit 0

    if [ "$security" = "Open" ]; then
      if nmcli dev wifi connect "$ssid" >/tmp/network-connect.log 2>&1; then
        notify-send "Network" "Connected to $ssid"
      else
        notify-send "Network" "$(tr '\n' ' ' </tmp/network-connect.log)"
      fi
      exit 0
    fi

    password="$(printf '\n' | wofi --dmenu --prompt "Password for $ssid" --style "$wstyle" --password || true)"
    [ -n "${password:-}" ] || exit 0

    if nmcli dev wifi connect "$ssid" password "$password" >/tmp/network-connect.log 2>&1; then
      notify-send "Network" "Connected to $ssid"
    else
      notify-send "Network" "$(tr '\n' ' ' </tmp/network-connect.log)"
    fi
    ;;
esac
