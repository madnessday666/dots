#!/bin/bash

AUDIO_DEVICE="none"
DIR="$(dirname "$(readlink -f "$0")")"
FRAMERATE=
POSITION=
SIZE=
ROFI_MENU="rofi -dmenu -i -no-custom $ROFI_THEME"
ROFI_THEME=

init() {
	if [ -f $HOME/.config/rofi/theme.rasi ]; then
		ROFI_THEME="-theme $HOME/.config/rofi/theme.rasi"
	fi
}

select_area() {
	dimension="$(echo "$(printf "Fullscreen\nArea")" | $ROFI_MENU -mesg "Select area")"
	if [ $dimension = "Fullscreen" ]; then
		area="$(xrandr --query --listactivemonitors \
							| grep ' connected ' \
							| sed -E 's/( connected)|( primary)|(\(.+)|( left)//g' \
							| cut -d ' ' -f2)"
		SIZE=$(sed 's/\(\(+\|\-\)[[:digit:]]\+\(+\|-\)[[:digit:]]\+\)//g' <<< "$area")
		POSITION=$(sed 's/\(^[[:digit:]]\+x[[:digit:]]\+\)//g;s/+//1;s/+/,/1' <<< "$area")
	else
		area="$(echo "$(slop)")"
		confirm="$(echo "$(printf "Yes\nNo")" | $ROFI_MENU -mesg "Сonfirm selected area? > $area")"
			if [ $confirm = "Yes" ]; then
				SIZE=$(sed 's/\(\(+\|\-\)[[:digit:]]\+\(+\|-\)[[:digit:]]\+\)//g' <<< "$area")
				POSITION=$(sed 's/\(^[[:digit:]]\+x[[:digit:]]\+\)//g;s/+//1;s/+/,/1' <<< "$area")
			else
				select_area
			fi
	fi
}

fix_area() {
	X=$(sed 's/x.*//g' <<< "$SIZE")
	Y=$(sed 's/.*x//g' <<< "$SIZE")
	while [ true ]; do
		if [ $((X%8)) -eq 0 ] && [ $((Y%8)) -eq 0 ];
		then
			break
		else
			if [ $((X%8)) -ne 0 ];
			then
				: $((--X))
			fi
			if [ $((Y%8)) -ne 0 ];
			then
				: $((--Y))
			fi
		fi
	done
	SIZE=$X'x'$Y
}

with_audio() {
	audio="$(echo "$(printf "Yes\nNo")" | $ROFI_MENU -mesg "Record input audio?")"
	if [ $audio = "Yes" ]; then
		select_audio_input
	fi
}

select_audio_input() {
	set -f
	audio_devices=$(sed 's/\*\*\*\*\sList\sof\sCAPTURE\sHardware\sDevices\s\*\*\*\*//g;
	s/\(Subdevice.*$\)\|\(^\s.*$\)\|\(^\s.*$\)//g;:a;N;s/\(\n\n\n\)\|\(^\n$\)\|\(\n$\)\|\(^\s.*s\)//g;
	s/\(\n\)//g;:a;N;s/\(^\s\)\|\(\n\)\|\(^card\s\)//g' <<< "$(arecord -l)")
	readarray -t devices <<< $audio_devices
	AUDIO_DEVICE=hw:"$(echo "$(printf "%s\n" "${devices[@]}")" | $ROFI_MENU -mesg "Select input device" | cut -c 1)"
	set +f
}

select_framerate() {
	FRAMERATE="$(echo "$(printf "30\n60")" | $ROFI_MENU -mesg "Select frame rate")"
}

start_record() {
	cd $DIR && touch stop
	<stop screencast -i $AUDIO_DEVICE -u -s $SIZE -p $POSITION -r $FRAMERATE -o $HOME/Screenrecs >/dev/null 2>> capture.log &
}

run() {
	init
	select_area
	fix_area
	with_audio
	select_framerate
	start_record
}

run

exit

