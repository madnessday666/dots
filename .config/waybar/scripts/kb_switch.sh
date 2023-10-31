#!/bin/bash
LAYOUT=$(hyprctl devices | rg -A 2 "micro-star-int'l-co.,ltd--msi-gk30-gaming-keyboard-" | grep -m 1 keymap | awk '{ print $3 }')
[[ "$LAYOUT" == "Russian" ]] && echo "RU" || echo "EN"
