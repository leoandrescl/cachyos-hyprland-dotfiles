#!/bin/sh
set -eu

cfg="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hypridle.conf"

if ! command -v hypridle >/dev/null 2>&1; then
  printf '%s\n' "[start-idle] hypridle no está instalado: no habrá apagado de pantalla / bloqueo / suspend por inactividad. Instala: sudo pacman -S hypridle" >>/tmp/hypr-start-idle.log
  exit 0
fi

if ! [ -f "$cfg" ]; then
  printf '%s\n' "[start-idle] falta $cfg" >>/tmp/hypr-start-idle.log
  exit 0
fi

if pgrep -x hypridle >/dev/null 2>&1; then
  exit 0
fi

# Config explícita; hereda WAYLAND_DISPLAY / HYPRLAND_INSTANCE_SIGNATURE del exec-once de Hyprland.
nohup hypridle -c "$cfg" >>/tmp/hypridle.log 2>&1 &
