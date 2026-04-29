#!/bin/sh
# GNOME Keyring para sesiones sin GNOME (Hyprland).
# --start solo sirve si PAM ya lanzó el daemon con --login; si no, hay que usar --daemonize.

set -eu

: "${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR no está definido (¿logind/systemd-user?)}"

ctl="${XDG_RUNTIME_DIR}/keyring/control"

if [ -S "$ctl" ]; then
  eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
else
  eval "$(/usr/bin/gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh)"
fi

# Apps y Cursor (libsecret) consultan el bus de sesión; sincroniza variables al entorno D-Bus.
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
  dbus-update-activation-environment SSH_AUTH_SOCK GNOME_KEYRING_CONTROL GNOME_KEYRING_PID \
    GPG_AGENT_INFO 2>/dev/null || true
fi

if command -v systemctl >/dev/null 2>&1; then
  systemctl --user import-environment SSH_AUTH_SOCK GNOME_KEYRING_CONTROL GNOME_KEYRING_PID \
    2>/dev/null || true
fi
