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

if [ $theme = 'dark' ]; then
  sed -i 's/\"colorscheme\": \".*\"/"colorscheme": "atom-dark"/' $HOME/.config/micro/settings.json
  sed -i 's/Inherits.*/Inherits=Breeze_Obsidian/' $HOME/.icons/default/index.theme
else
  sed -i 's/\"colorscheme\": \".*\"/"colorscheme": "bubblegum"/' $HOME/.config/micro/settings.json
  sed -i 's/Inherits.*/Inherits=Breeze_Snow/' $HOME/.icons/default/index.theme
fi

ln -sf $dir/themes/$theme/alacritty.toml $HOME/.config/alacritty/alacritty.toml
ln -sf $dir/themes/$theme/dunstrc $HOME/.config/dunst/dunstrc
ln -sf $dir/themes/$theme/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -sf $dir/themes/$theme/theme.rasi $HOME/.config/rofi/theme.rasi
ln -sf $dir/themes/$theme/config.ini $HOME/.config/polybar/config.ini
ln -sf $dir/themes/$theme/wallpapers.png $HOME/.config/wallpapers/wallpapers.png

bspc wm -r

