#!/bin/sh

max=$(brightnessctl max)
current=$(brightnessctl get)
if [ -z "$max" ] || [ "$max" -eq 0 ]; then
    exit 1
fi
percent=$((current * 100 / max))
index=$((percent / 10))
[ "$index" -gt 10 ] && index=10
# Nerd Font brightness-low through brightness-high form one progressive icon family.
icons='󰃞 󰃟 󰃠 󰃡 󰃢 󰃣 󰃤 󰃥 󰃦 󰃧 󰃨'
icon=$(printf '%s\n' "$icons" | cut -d' ' -f$((index + 1)))
printf '{"text":"%s %d%%","tooltip":"Brightness: %d%%","class":"brightness"}\n' "$icon" "$percent" "$percent"
