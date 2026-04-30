# cachyos-hyprland-dotfiles

[![CachyOS / Arch](https://img.shields.io/badge/CachyOS-Arch-1793D1?logo=archlinux&logoColor=white)](https://cachyos.org/)
[![Hyprland](https://img.shields.io/badge/Compositor-Hyprland-58a6ff)](https://hyprland.org/)
[![Wayland](https://img.shields.io/badge/Display-Wayland-333333)](https://wayland.freedesktop.org/)
[![Shell](https://img.shields.io/badge/Shell-fish-34c534)](https://fishshell.com/)

Dotfiles para **Hyprland + Wayland** (CachyOS / Arch). Clona, copia `home/.config` sobre tu `~/.config`, ajusta monitores y usuario SDDM.

---

## Instalación

```fish
git clone https://github.com/leoandrescl/cachyos-b550-hyprland-dotfiles.git
set REPO ~/cachyos-b550-hyprland-dotfiles
cp -a "$REPO/home/.config/." ~/.config/
```

| Paso | Acción |
|------|--------|
| 1 | Backup previo de `~/.config` si ya tienes cosas importantes. |
| 2 | En `~/.config/sddm/<tema>/theme.conf`: `defaultUser=CHANGE_ME` → tu usuario (`whoami`). |
| 3 | Misma ruta: `background=` apuntando a una imagen que exista en ese PC. |
| 4 | `~/.config/hypr/conf.d/10-monitors.conf`: salidas y resoluciones (`hyprctl monitors`). |
| 5 | Opcional: `xdg-user-dirs-update` para carpetas XDG; Fish instala temas/plugins aparte (`fish_variables` no va en el repo). |
| 6 | Cerrar sesión o `hyprctl reload` tras cambios puntuales de Hyprland. |

> [!TIP]
> En SDDM, el **nombre de la carpeta** bajo `~/.config/sddm/` es el **ID del tema** (lo eliges en la config del display manager). Aquí se llama `lain-custom/` por costumbre del autor; puedes renombrarla siempre que uses el **mismo nombre** en la selección de tema de SDDM.

---

## Qué incluye `home/.config/`

| Directorio | Uso |
|------------|-----|
| `hypr/` | `hyprland.conf`, `conf.d/`, hypridle, hyprlock, scripts, keyring |
| `waybar/` | Barra (rutas con `$HOME`) |
| `wofi/` | Lanzador |
| `dunst/` | Notificaciones |
| `fish/` | `config.fish` |
| `xdg-desktop-portal/` | `portals.conf` |
| `sddm/` | Tema SDDM (subcarpeta = nombre del tema) |

---

## Paquetes (referencia `pacman`)

```text
hyprland hypridle hyprlock waybar wofi dunst fish
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
polkit-kde-agent udisks2 ntfs-3g networkmanager wireplumber
```

Ajusta según lo que uses (scripts de red, audio, etc.).

---

## Versionado con Git (opcional)

```fish
git tag -a v1.0.0 -m "Base Hyprland + SDDM"
git push origin v1.0.0
```

En GitHub: **Releases → Draft a new release** y elige esa tag. Para clonar una versión concreta: `git clone --branch v1.0.0 <url>`.
