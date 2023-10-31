#!/bin/sh

# Check which waybar theme is set
THEMEIS=$(readlink -f ~/.config/waybar/style.css | cut -d '-' -f2)

#if the theme is not dark then we need to switch to it
if [[ $THEMEIS == "light.css" ]]; then
    SWITCHTO="-dark"
    MODESTR="Dark"
else
    MODESTR="Light"
    SWITCHTO="-light"
fi

#Set the waybar theme
ln -sf ~/.config/waybar/styles/'style'$SWITCHTO.css ~/.config/waybar/style.css

#Set kitty theme
ln -sf ~/.config/kitty/'kitty'$SWITCHTO'.conf' ~/.config/kitty/current-theme.conf
ln -sf ~/.config/kitty/'kitty'$SWITCHTO'.conf' ~/.config/kitty/kitty.conf

#Set rofi theme
ln -sf ~/.config/rofi/'colors'$SWITCHTO'.rasi' ~/.config/rofi/colors.rasi

#Set firefox theme
ln -sf ~/.mozilla/firefox/xcz1c6jp.default/cfg/'prefs'$SWITCHTO.js ~/.mozilla/firefox/xcz1c6jp.default/user.js

#Set background image
#swww img ~/.config/hypr/wallpapers/'wallpaper'$SWITCHTO.jpg --transition-fps 90 --transition-type wipe --transition-duration 1

#Set GTK theme
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis'$SWITCHTO
gsettings set org.gnome.desktop.interface color-scheme 'prefer'$SWITCHTO
export GTK_THEME='Orchis'$SWITCHTO;                                                                                                                             08:02:28

#restart the waybar
#killall -SIGUSR2 waybar #<-- start causing web brwsers to close so switched to below...
pkill kitty
pkill waybar
hyprctl reload
LC_TIME="ru_RU.UTF-8" waybar &
