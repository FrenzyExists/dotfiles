#!/usr/bin/env bash

#cat ~/.scripts/menu/emoji.txt |rofi -dmenu -i -p "Which emoji? ⭐ " -theme /$HOME/.config/rofi/minimal.rasi -font "twemoji 16" | awk '{print $1}' | tr -d '\n' | xclip -selection clipboard
cat ~/.scripts/menu/emoji/emoji.txt |rofi -dmenu -i -p "⭐" -theme ~/.config/rofi/styles/aquarium_dark.rasi  -font "Operator Mono 11" | awk '{print $1}' | tr -d '\n' | xclip -selection clipboard
