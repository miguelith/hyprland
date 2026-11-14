#!/usr/bin/env bash

source_state=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null) || exit 0
volume=$(awk '{printf "%.0f%%", $2 * 100}' <<< "$source_state")

if [[ "$source_state" == *"[MUTED]"* ]]; then
    printf '{"text":"󰍭","tooltip":"Input muted (%s)","class":"muted"}\n' "$volume"
else
    printf '{"text":"󰍬","tooltip":"Input: %s"}\n' "$volume"
fi
