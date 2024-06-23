#!bin/bash

is_muted=$(echo $(pactl get-source-mute @DEFAULT_SOURCE@) | sed 's/Mute: //')
color_red=$(cat $HOME/.config/polybar/colors.ini | grep alert | awk '{print $3}')
if [ $is_muted = 'yes' ]; then
  echo "%{F$color_red}%{F-}"
else
  echo ""
fi
