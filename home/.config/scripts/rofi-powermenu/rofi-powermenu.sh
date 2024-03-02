#!/bin/bash

LOCK="LOCK"
LOGOUT="LOGOUT"
REBOOT="REBOOT"
SHUTDOWN="SHUTDOWN"
SUSPEND="SUSPEND"

commands=($SHUTDOWN $REBOOT $LOCK $SUSPEND $LOGOUT)

selection=$(echo -e "$SHUTDOWN\n$REBOOT\n$LOCK\n$SUSPEND\n$LOGOUT" | rofi -dmenu -theme powermenu -xoffset $1 -yoffset $2)

case $selection in
  $LOCK )
  xscreensaver-command -lock
  break
  ;;
  $LOGOUT )
  loginctl kill-session self
  break
  ;;
  $REBOOT )
  loginctl reboot
  break
  ;;
  $SHUTDOWN )
  loginctl poweroff
  break
  ;;
  $SUSPEND )
  loginctl suspend
  break
  ;;
esac

exit

