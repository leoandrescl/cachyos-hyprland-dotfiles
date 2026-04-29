# cachyos-b550-hyprland-dotfiles

Dotfiles públicos para **Hyprland (Wayland)** en CachyOS / Arch: lo mínimo para clonar en otro PC y tener el mismo entorno con pocos pasos.

## ¿Repo público?

Sí puede ser buena idea si **no** subes secretos ni estado privado. Este repo está pensado para eso: solo configs y scripts, sin `fish_variables`, sin backups, sin rutas fijas a `/home/tuusuario` (Waybar usa `$HOME`). Aun así, **revisa antes de cada push** (`git diff`) por si añadiste algo personal.

## Contenido (`home/.config/`)

| Ruta | Qué es |
|------|--------|
| `hypr/` | Hyprland modular (`conf.d/`), idle, lock, scripts, keyring |
| `waybar/` | Barra |
| `wofi/` | Lanzador / menús |
| `dunst/` | Notificaciones |
| `fish/` | Solo `config.fish` (CachyOS fish + ajustes mínimos) |
| `xdg-desktop-portal/` | `portals.conf` |
| `sddm/lain-custom/` | Tema SDDM (editar usuario abajo) |

Carpetas vacías en tu máquina (p. ej. `kitty/`, `autostart/`) no se versionan.

## Instalación en otro PC

1. Clonar y copiar sobre `~/.config` (haz backup antes):

```fish
git clone https://github.com/leoandrescl/cachyos-b550-hyprland-dotfiles.git
set REPO ~/cachyos-b550-hyprland-dotfiles
cp -a "$REPO/home/.config/." ~/.config/
```

2. **SDDM:** en `~/.config/sddm/lain-custom/theme.conf` cambia `defaultUser=CHANGE_ME` por tu usuario (`whoami`). Ajusta `background=` si no tienes la misma ruta de wallpaper.

3. **Monitores:** edita `~/.config/hypr/conf.d/10-monitors.conf` a tus salidas y resoluciones (`hyprctl monitors`).

4. **XDG carpetas de usuario** (opcional): `xdg-user-dirs-update` o crea `user-dirs.dirs` a mano; no van en el repo.

5. **Fish:** las variables universales (`fish_variables`) las genera Fish en cada máquina; si usas tema **pure** u otro, instálalo en ese PC (`fisher`, etc.) como en tu instalación original.

6. Cierra sesión o reinicia; en Hyprland: `hyprctl reload` cuando toques solo binds/look.

## Paquetes orientativos (Arch/CachyOS)

`hyprland` `hypridle` `hyprlock` `waybar` `wofi` `dunst` `fish` `xdg-desktop-portal-hyprland` `xdg-desktop-portal-gtk` `polkit-kde-agent` `udisks2` `ntfs-3g` `networkmanager` `wireplumber` … (ajusta a lo que uses en scripts y barra.)
