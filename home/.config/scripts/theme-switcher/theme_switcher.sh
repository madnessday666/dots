#!/bin/bash

ROFI_MENU="rofi -dmenu -i -no-custom"
ROFI_THEME=
dir="$(dirname "$(readlink -f "$0")")"

if [ -f $HOME/.config/rofi/theme.rasi ]; then
		ROFI_THEME="-theme $HOME/.config/rofi/theme.rasi"
		ROFI_MENU="rofi -dmenu -i -no-custom $ROFI_THEME"
fi

theme="$(echo "$(printf "dark\nlight")" | $ROFI_MENU -mesg "Select theme")"

if [ -z $theme ]; then 
  exit
fi

if [ ! -f $HOME/.config/micro/settings.json ]; then
  echo '{
    "colorscheme": "default"
}' | tee $HOME/.config/micro/settings.json >/dev/null
fi

if [ $theme = 'dark' ];then
  sed -i 's/\"colorscheme\": \".*\"/"colorscheme": "atom-dark"/' $HOME/.config/micro/settings.json
else
  sed -i 's/\"colorscheme\": \".*\"/"colorscheme": "bubblegum"/' $HOME/.config/micro/settings.json
fi

rm $HOME/.config/alacritty/alacritty.toml
rm $HOME/.config/gtk-3.0/settings.ini
rm $HOME/.config/polybar/config.ini
rm $HOME/.config/rofi/theme.rasi
rm $HOME/.config/wallpapers/wallpapers.png

ln -s $dir/themes/$theme/alacritty.toml $HOME/.config/alacritty/alacritty.toml
ln -s $dir/themes/$theme/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -s $dir/themes/$theme/theme.rasi $HOME/.config/rofi/theme.rasi
ln -s $dir/themes/$theme/config.ini $HOME/.config/polybar/config.ini
ln -s $dir/themes/$theme/wallpapers.png $HOME/.config/wallpapers/wallpapers.png

for pid in `ps -ef | grep dbus-daemon | awk '{print $2}'` ; do kill $pid ; done
pkill dbus-launch
pkill dunst
pkill clipit

bspc wm -r

