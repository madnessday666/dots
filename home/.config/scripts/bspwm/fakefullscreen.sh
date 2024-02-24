#!/bin/bash

X=$(sed 's/x.*//g' <<< "$(xrandr | grep "*" | awk '{ print $1 }')")
Y=$(sed 's/.*x//g' <<< "$(xrandr | grep "*" | awk '{ print $1 }')")

WINDOW_ID="$(xdotool getwindowfocus)"
bspc node -t floating
xdotool windowmove $WINDOW_ID 0 0
xdotool windowsize $WINDOW_ID $X $Y

exit
