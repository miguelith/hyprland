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
│   ├── nwg-bar/
│   ├── swappy/
│   ├── systemd/
│   ├── udiskie/
│   └── uwsm/
├── .local/
│   └── bin/
├── system/
│   └── 01-battery.conf     # TLP config (deployed to /etc/tlp.d/ manually)
├── Pictures/
│   └── Wallpapers/
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
- `qt6-wayland`

No GUI theme tools are required: all theme settings are tracked declaratively in this repo (`settings.ini`, `dconf/user.txt`, `hyprqt6engine.conf`, `kdeglobals`).

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

## Theme definition (authoritative)

Everything is Adwaita dark. No extra theme engines (Kvantum, adw-qt, qt6ct, etc.).

| Toolkit | Authority | Mechanism |
|---|---|---|
| libadwaita (GTK4) | dconf `color-scheme='prefer-dark'` | follows automatically |
| GTK3 / GTK4 | `.config/gtk-3.0/settings.ini`, `.config/gtk-4.0/settings.ini` | `adw-gtk3` + `gtk-application-prefer-dark-theme=1` |
| Qt / KDE apps | `.config/hypr/hyprqt6engine.conf` | `QT_QPA_PLATFORMTHEME=hyprqt6engine`; the `hypr` widget style follows libadwaita, and the engine loads the tracked `LibadwaitaDark.colors` scheme and exports `KDE_COLOR_SCHEME_PATH` to apps itself |

Rules:

- Do **not** set `QT_STYLE_OVERRIDE` — it overrides the engine and breaks dark-mode text/background colors.
- Do **not** set `GTK_THEME` or `GTK_FONT` env vars — `settings.ini` + dconf are the single GTK authorities.
- Do **not** set `KDE_COLOR_SCHEME_PATH` in `uwsm/env` — `hyprqt6engine` exports it per-app from its own config.
- `.config/kdeglobals` embeds the `LibadwaitaDark` `[Colors:*]` groups (generated from the scheme file): KColorScheme uses them to recolor Breeze symbolic icons — without them, sidebar icons render black-on-black. Also sets `widgetStyle=hypr` and `[Icons] Theme=Breeze`.
- Icon theme: **Adwaita everywhere** (GTK and Qt/KDE, via `theme.icon_theme` and `kdeglobals [Icons]`). Breeze/BreezeDark were tried for KDE but render inconsistently (symbolic icons black-on-dark); Adwaita's full-color icons stay visible on dark backgrounds.
- The single color source for the dark palette is `.local/share/color-schemes/LibadwaitaDark.colors`, referenced by `hyprqt6engine.conf`.

Relevant files:

```text
.config/hypr/hyprqt6engine.conf   # Qt: style = hypr (follows libadwaita), color scheme, fonts, icons
.config/uwsm/env                  # session-wide env vars (QT_QPA_PLATFORMTHEME, ...). No GTK_THEME: settings.ini + dconf are the authorities
.local/share/color-schemes/LibadwaitaDark.colors  # the single dark palette source
.config/kdeglobals                # KConfig fallback for KDE apps
```

Note: `~/.local/share/` is gitignored except this one tracked file, which `stow --no-folding` symlinks into place automatically.

Changes to `uwsm/env` only take effect after re-logging into the session.

## Battery optimization (ThinkPad T430)

TLP handles power management. The config is tracked in the repo:

```text
system/01-battery.conf
```

Deploy it (this file lives outside `$HOME`, so Stow can't link it):

```sh
sudo cp ~/dotfiles/hyprland/system/01-battery.conf /etc/tlp.d/
sudo tlp start
```

What it does:

- CPU: `performance` governor/EPB on AC, `powersave`/`power` on battery; turbo boost off on battery
- Platform profile: `low-power` on battery
- WiFi/Bluetooth power saving on battery; Wake-on-LAN disabled
- Runtime PM (PCIe `powersupersave` on battery, SATA ALPM, disk APM + spindown, USB autosuspend, audio power save)
- Charge thresholds: start **40%**, stop **80%** — the biggest lifespan win for an aging ThinkPad battery (verified active: `sudo tlp-stat -b`)
- Bluetooth/WWAN powered off when idle on battery

Dependencies: `tlp` (and `ethtool` for WoL disable). Do not install `power-profiles-daemon` alongside it — TLP conflicts with it.

## Maintenance

This repository is the source of truth for the Hyprland desktop configuration.

Edit files here and let GNU Stow maintain the symlinks.

