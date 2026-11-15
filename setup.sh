#!/usr/bin/env bash
# Post-stow setup: steps that can't be done by symlinking alone.
# Run after `cd ~/dotfiles && stow -t ~ hyprland`.
set -euo pipefail

cd "$(dirname "$0")"

echo '== TLP battery config -> /etc/tlp.d/'
sudo cp -v system/01-battery.conf /etc/tlp.d/
sudo tlp start

echo '== dconf settings'
dconf load / < .config/dconf/user.txt

echo '== wallpapers -> ~/Pictures/Wallpapers'
mkdir -p ~/Pictures/Wallpapers
cp -v Pictures/Wallpapers/* ~/Pictures/Wallpapers/

echo '== done. Log out/in once for uwsm/env changes.'
