#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
WHITE='#dfdfdf'
RED='#B2535B'
YELLOW='#aaaa55'
STATUS="$(cat $DIR/status)"

if [ $STATUS = 'record' ]; then
    echo "%{F$RED} %{F-}"
elif [ $STATUS = 'render' ]; then
	if [ -z "$(ls $HOME/.cache/screencast)" ]; then
	sed -i 's/.*/idle/' $DIR/status
	echo "%{F$WHITE} %{F-}"
	else
	echo "%{F$YELLOW} %{F-}"
	fi
else
	echo "%{F$WHITE} %{F-}"
fi

exit
