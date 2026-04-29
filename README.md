# cachyos-b550-hyprland-dotfiles

Configuraciones de **Hyprland (Wayland)** en CachyOS para esta máquina: barra, terminal, notificaciones, portal, shell, tema GTK, SDDM y autostart.

## Qué hay en `home/.config/`

| Carpeta / archivo | Rol |
|-------------------|-----|
| `hypr/` | Hyprland, hypridle, hyprlock, scripts, `conf.d/` modular |
| `waybar/` | Barra Wayland |
| `kitty/` | Terminal |
| `dunst/` | Notificaciones |
| `wofi/` | Lanzador |
| `fish/` | Shell |
| `xdg-desktop-portal/` | Portales (pantalla, etc.) |
| `gtk-3.0/` | Tema / ajustes GTK3 |
| `sddm/` | Tema / recursos SDDM (`lain-custom`) |
| `autostart/` | `.desktop` de autostart |
| `session/` | Archivos de sesión |
| `btop/` | Monitor de sistema |
| `dolphinrc`, `user-dirs.*`, etc. | Ajustes varios de escritorio |

Incluye `exec-once` del **agente PolicyKit** (`polkit-kde-authentication-agent-1`) para montar discos desde Dolphin sin GNOME/KDE completos.

## Cómo aplicar en otra instalación (o tras formatear)

Copiar encima de tu `~/.config` (haz backup antes):

```fish
set REPO ~/Projects/cachyos-b550-hyprland-dotfiles
cp -a "$REPO/home/.config/." ~/.config/
```

O solo partes concretas, por ejemplo solo Hyprland:

```fish
cp -a ~/Projects/cachyos-b550-hyprland-dotfiles/home/.config/hypr ~/.config/
```

Cierra sesión o reinicia Hyprland tras cambios grandes (`hyprctl reload` no recarga todo).

## Requisitos típicos en Arch/CachyOS

Paquetes orientativos (ajusta a lo que uses): `hyprland`, `waybar`, `kitty`, `dunst`, `wofi`, `fish`, `xdg-desktop-portal-hyprland`, `xdg-desktop-portal-gtk`, `polkit-kde-agent`, `udisks2`, `ntfs-3g`, etc.
