# Hyprland Dotfiles

Personal Hyprland desktop environment configuration.

Contains everything required for the custom Wayland session, including the compositor, status bar, launchers, notifications, theming, user services, and helper scripts.

## Structure

```text
hyprland/
├── .config/
│   ├── hypr/
│   ├── waybar/
│   ├── wofi/
│   ├── wlogout/
│   ├── dunst/
│   ├── ghostty/
│   ├── gtk-3.0/
│   ├── gtk-4.0/
│   ├── qt6ct/
│   ├── nwg-bar/
│   ├── swappy/
│   ├── systemd/
│   ├── udiskie/
│   └── uwsm/
├── .local/
│   └── bin/
├── Pictures/
│   └── Wallpapers/
├── .gtkrc-2.0
├── .stowrc                 # --no-folding: per-file symlinks, no directory folds
└── README.md
```

## Deployment

Install GNU Stow, then run from the parent directory:

```sh
cd ~/dotfiles
stow -t ~ hyprland
```

To remove the deployed symlinks:

```sh
stow -D -t ~ hyprland
```

The tracked `.stowrc` sets `--no-folding` by default: by default Stow "folds" directories, replacing e.g. `~/.local/share` with a single symlink into the repo. Anything an application then writes under `~/.local/share` would land inside the repository. With `--no-folding`, Stow symlinks each file individually (`~/.local/share/color-schemes/LibadwaitaDark.colors`, `~/.local/bin/*`, ...) so runtime data stays out of the repo. `.local/share/` is additionally gitignored as a safety net, except for explicitly tracked config files.

## Dependencies

### Core session

- `hyprland`
- `uwsm`
- `hyprlock`
- `hyprpaper`
- `hyprpicker`
- `hyprpolkitagent`
- `hyprshutdown`
- `hyprsunset`
- `hyprland-qt-support`
- `hyprqt6engine`
- `ghostty`
- `xdg-desktop-portal-hyprland`
- `xdg-desktop-portal-gtk`
- `pipewire`
- `wireplumber`
- `pipewire-pulse`
- `pavucontrol`

### Shell UI

- `waybar`
- `wofi`
- `wlogout`
- `nwg-bar`
- `dunst`
- `libnotify`
- `grim`
- `slurp`
- `swappy`
- `brightnessctl`
- `playerctl`

### Theming

- `adw-gtk-theme`
- `adwaita-icon-theme`
- `qt6ct`
- `qt5-wayland`
- `qt6-wayland`

No GUI theme tools are required: all theme settings are tracked declaratively in this repo (`settings.ini`, `dconf/user.txt`, `qt6ct.conf`, `.gtkrc-2.0`).

Fonts:

- `noto-fonts-cjk`
- `noto-fonts-emoji`
- `ttf-jetbrains-mono-nerd`

### System and services

- `networkmanager`
- `network-manager-applet`
- `tailscale`
- `cloudflare-warp`
- `udiskie`
- `trash-cli`
- `cliphist`
- `wl-clipboard`
- `dolphin`
- `polkit`

Systemd user units:

- `cliphist-clear.service`
- `cliphist-clear.timer`

## GTK and desktop settings

Some desktop preferences are stored in dconf rather than ordinary configuration files.

The repository includes a declarative dconf dump:

```text
.config/dconf/user.txt
```

Current settings:

```ini
[org/gnome/desktop/interface]
color-scheme='prefer-dark'
gtk-theme='adw-gtk3'
```

### Applying dconf settings

After deploying the Stow package, import the settings:

```sh
dconf load / < ~/.config/dconf/user.txt
```

This imports the tracked preferences into the user's dconf database. It only needs to be repeated when the tracked settings change or when setting up a new installation.

## Dark theme strategy

Everything uses Adwaita dark. No extra theme engines (Kvantum, adw-qt, etc.) are required.

- **GTK apps**: `adw-gtk3` dark via `GTK_THEME=adw-gtk3:dark`, `gtk-application-prefer-dark-theme=1`, and dconf `color-scheme='prefer-dark'`.
- **Qt apps**: `hyprqt6engine` (ships with Hyprland) as the Qt platform theme (`QT_QPA_PLATFORMTHEME=hyprqt6engine`). Its `hypr` widget style follows libadwaita automatically. Do **not** set `QT_STYLE_OVERRIDE` — it overrides the engine and breaks dark-mode text/background colors.
- **KDE apps (Dolphin)**: follow the `LibadwaitaDark` color scheme, applied via `KDE_COLOR_SCHEME_PATH` and `kdeglobals`. The color scheme file lives at `~/.local/share/color-schemes/LibadwaitaDark.colors`.

Relevant files:

```text
.config/hypr/hyprqt6engine.conf   # Qt style = hypr, color scheme, fonts
.config/uwsm/env                  # session-wide env vars (GTK_THEME, QT_QPA_PLATFORMTHEME, ...)
.config/qt6ct/qt6ct.conf          # fallback Qt6 config (style = hypr)
.local/share/color-schemes/LibadwaitaDark.colors  # KDE color scheme (Dolphin)
```

Note: `~/.local/share/` is gitignored except this one tracked file, which `stow --no-folding` symlinks into place automatically.

Changes to `uwsm/env` only take effect after re-logging into the session.

## System-level configuration

Some configurations require changes outside the user's home directory.

### VPN sudoers rule

File:

```text
/etc/sudoers.d/vpn-toggle
```

Permissions:

```sh
sudo chmod 440 /etc/sudoers.d/vpn-toggle
```

Contents:

```text
miguelith ALL=(root) NOPASSWD: /usr/bin/systemctl start tailscaled.service, /usr/bin/systemctl stop tailscaled.service, /usr/bin/tailscale up, /usr/bin/tailscale down, /usr/bin/tailscale status, /usr/bin/systemctl start warp-svc.service, /usr/bin/systemctl stop warp-svc.service, /usr/bin/warp-cli connect, /usr/bin/warp-cli disconnect, /usr/bin/warp-cli status
```

This allows the Waybar VPN module and keybindings to control VPN services without password prompts.

## VPN control

- `SUPER + SHIFT + V` — Opens the VPN selection menu.
- Waybar `custom/vpn` module — Displays VPN status.
- Left-click — Opens `vpn-menu`.
- Right-click — Displays VPN status.

CLI usage:

```sh
vpn status
vpn off
vpn warp
vpn tailscale
```

Requires Tailscale and Cloudflare WARP.

## Maintenance

This repository is the source of truth for the Hyprland desktop configuration.

Edit files here and let GNU Stow maintain the symlinks.

