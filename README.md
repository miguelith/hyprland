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
│   ├── qt5ct/
│   ├── qt6ct/
│   ├── Kvantum/
│   ├── nwg-bar/
│   ├── nwg-look/
│   ├── swappy/
│   ├── systemd/
│   ├── udiskie/
│   └── uwsm/
├── .local/
│   └── bin/
├── Pictures/
│   └── Wallpapers/
├── .gtkrc-2.0
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

- `adw-gtk3`
- `adwaita-icon-theme`
- `nwg-look`
- `qt5ct`
- `qt6ct`
- `kvantum`
- `qt5-wayland`
- `qt6-wayland`

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

