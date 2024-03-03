#!/bin/bash

ROFI_MENU="rofi -dmenu -i -no-custom -theme $HOME/.config/rofi/theme.rasi"
dir="$(dirname "$(readlink -f "$0")")"

theme="$(echo "$(printf "dark\nlight")" | $ROFI_MENU -mesg 'SELECT THEME <span foreground="red">(WARNING: ALL WINDOWS WILL BE CLOSED!)</span>')"

if [ -z $theme ]; then 
  exit
fi

if [ ! -f $HOME/.config/micro/settings.json ] || [ echo $(cat $HOME/.config/micro/settings.json) = '{}' ]; then
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

bgColor=$(cat $dir/themes/$theme/alacritty.toml | grep background | cut -d ' ' -f 3)
fgColor=$(cat $dir/themes/$theme/alacritty.toml | grep foreground | cut -d ' ' -f 3)
row=$row"s/.*background = { common.color \"#.*\" },.*\s/  background = { common.color $bgColor },\n/;"
row=$row"s/.*text = { common.color \"#.*\" },.*\s/  text = { common.color $fgColor },\n/;"
while read line
    do
      case $line in
        *black* )
        row=$row"s/.*\[  0\] = { common.color.*/    \[  0\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[  8\] = { common.color.*/    \[  8\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *blue* )
        row=$row"s/.*\[  4\] = { common.color.*/    \[  4\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[ 12\] = { common.color.*/    \[ 12\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *cyan* )
        row=$row"s/.*\[  6\] = { common.color.*/    \[  6\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[ 14\] = { common.color.*/    \[ 14\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *green* )
        row=$row"s/.*\[  2\] = { common.color.*/    \[  2\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[ 10\] = { common.color.*/    \[ 10\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *magenta* )
        row=$row"s/.*\[  5\] = { common.color.*/    \[  5\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[ 13\] = { common.color.*/    \[ 13\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *red* )
        row=$row"s/.*\[  1\] = { common.color.*/    \[  1\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[  9\] = { common.color.*/    \[  9\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *white* )
        row=$row"s/.*\[  7\] = { common.color.*/    \[  7\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[ 15\] = { common.color.*/    \[ 15\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *yellow* )
        row=$row"s/.*\[  3\] = { common.color.*/    \[  3\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        row=$row"s/.*\[ 11\] = { common.color.*/    \[ 11\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },/;"
        ;;
        *colors.normal* )
        break
        ;;
      esac
  done < "$dir/themes/$theme/alacritty.toml"
perl -pi -e "$row" $HOME/.config/lite-xl/plugins/terminal/init.lua

cp $dir/themes/$theme/alacritty.toml $HOME/.config/alacritty/alacritty.toml
cp $dir/themes/$theme/dunstrc $HOME/.config/dunst/dunstrc
cp $dir/themes/$theme/settings.ini $HOME/.config/gtk-3.0/settings.ini
cp $dir/themes/$theme/colors.rasi $HOME/.config/rofi/colors.rasi
cp $dir/themes/$theme/colors.ini $HOME/.config/polybar/colors.ini
cp $dir/themes/$theme/wallpapers.png $HOME/.config/wallpapers/wallpapers.png

bspc wm -r

