#!/bin/bash

PRIMARY=$(cat $HOME/.config/polybar/colors.ini | grep 'foreground =' | awk '{print $3}')
RED=$(cat $HOME/.config/polybar/colors.ini | grep alert | awk '{print $3}')
YELLOW='#aaaa55'
DIR="$(dirname "$(readlink -f "$0")")"
STATUS=

if [ ! -e "$DIR/status" ]; then
	touch $DIR/status
	echo "idle" >> $DIR/status
	if [ "$(pidof parec)" ]; then
		sed -i 's/.*/record/' $DIR/status
		echo "%{F$RED} %{F-}"
	elif [ ! "$(pidof parec)" ] && [ -n "$(ls $HOME/.cache/recs)" ]; then
		sed -i 's/.*/render/' $DIR/status
		echo "%{F$YELLOW} %{F-}"
	elif [ ! "$(pidof parec)" ] && [ -z "$(ls $HOME/.cache/recs)" ]; then
    	sed -i 's/.*/idle/' $DIR/status
		echo "%{F$PRIMARY} %{F-}"
	fi
else
	STATUS="$(cat $DIR/status)"
	if [ $STATUS = 'record' ]; then
    	echo "%{F$RED} %{F-}"
	elif [ $STATUS = 'render' ]; then
		if [ ! "$(pidof ffmpeg)" ] && [ -z "$(ls $HOME/.cache/recs)" ]; then
			sed -i 's/.*/idle/' $DIR/status
			echo "%{F$PRIMARY} %{F-}"
		else
			echo "%{F$YELLOW} %{F-}"
		fi
	else
	echo "%{F$PRIMARY} %{F-}"
	fi
fi

exit
