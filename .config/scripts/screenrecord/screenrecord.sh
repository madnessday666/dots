#!/bin/bash


AUDIO_DEVICE=
AUDIO_SETTINGS=
DIR="$(dirname "$(readlink -f "$0")")"
CACHE="$HOME/.cache/recs"
COLOR_RANGE=2
INPUT="0.0"
FILENAME="$(date +"%Y-%m-%d_%H:%M:%S")"
FRAMERATE=
PIXEL_FORMAT="yuv420p"
POSITION=
SAVEDIR="$HOME/Screenrecs"
SIZE=
STATUS="$(cat $DIR/status)"
ROFI_THEME=
ROFI_MENU="rofi -dmenu -i -no-custom"
WITH_AUDIO=

init() {
	if [ -f $SAVEDIR ]; then
		mkdir $SAVEDIR
	fi

	if [ -f $HOME/.config/rofi/theme.rasi ]; then
		ROFI_THEME="-theme $HOME/.config/rofi/theme.rasi"
		ROFI_MENU="rofi -dmenu -i -no-custom $ROFI_THEME"
	fi
}

is_recording() {
	if [ $STATUS = 'record' ]; then
        cd $DIR && echo 'q' > stop
        pkill parec
        rm $DIR/stop
		sed -i 's/.*/render/' $DIR/status
		exit
	fi
}

select_area() {
	dimension="$(echo "$(printf "Fullscreen\nArea\nCancel")" | $ROFI_MENU -mesg "Select area")"
	if [ $dimension = "Fullscreen" ]; then
		area="$(xrandr --query --listactivemonitors \
							| grep ' connected ' \
							| sed -E 's/( connected)|( primary)|(\(.+)|( left)//g' \
							| cut -d ' ' -f2)"
		SIZE=$(sed 's/\(\(+\|\-\)[[:digit:]]\+\(+\|-\)[[:digit:]]\+\)//g' <<< "$area")
		POSITION=$(sed 's/\(^[[:digit:]]\+x[[:digit:]]\+\)//g;s/+//1;s/+/,/1' <<< "$area")
	elif [ $dimension = "Area" ]; then
		area="$(echo "$(slop)")"
		confirm="$(echo "$(printf "Yes\nNo")" | $ROFI_MENU -mesg "Сonfirm selected area? > $area")"
			if [ $confirm = "Yes" ]; then
				SIZE=$(sed 's/\(\(+\|\-\)[[:digit:]]\+\(+\|-\)[[:digit:]]\+\)//g' <<< "$area")
				POSITION=$(sed 's/\(^[[:digit:]]\+x[[:digit:]]\+\)//g;s/+//1;s/+/,/1' <<< "$area")
			else
				select_area
			fi
	else
		exit
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
	WITH_AUDIO="$(echo "$(printf "No\nYes\nCancel")" | $ROFI_MENU -mesg "Record input audio?")"
	if [ $WITH_AUDIO = "Yes" ]; then
		select_audio_input
	elif [ $WITH_AUDIO = "No" ]; then
		:
	else
		exit
	fi
}

select_audio_input() {
	AUDIO_DEVICE=("$(pactl list short sources | cut -f2)")
	AUDIO_DEVICE="$(echo "$(printf "%s\n" "${AUDIO_DEVICE[@]}")" | $ROFI_MENU -mesg "Select input device")"
}

select_framerate() {
	FRAMERATE="$(echo "$(printf "60\n30\nCancel")" | $ROFI_MENU -mesg "Select frame rate")"
	if [ $FRAMERATE != 60 ] && [ $FRAMERATE != 30 ]; then
		exit
	fi
}

start_record() {
	cd $DIR && touch stop
	sed -i 's/.*/record/' $DIR/status
	mkdir -p $CACHE/$FILENAME

	if [ $WITH_AUDIO = "Yes" ]; then
		AUDIO_SETTINGS="-i $CACHE/$FILENAME/$FILENAME.wav"
		parec \
		-d $AUDIO_DEVICE \
		--file-format=wav $CACHE/$FILENAME/$FILENAME.wav &
	fi

	<stop \
	ffmpeg \
	-video_size $SIZE \
	-framerate $FRAMERATE \
	-f x11grab \
	-i :$INPUT \
	-c:v libx264rgb \
	-crf 0 \
	-preset ultrafast \
	-color_range $COLOR_RANGE \
	$CACHE/$FILENAME/$FILENAME.mkv >/dev/null 2>> capture.log \
	&& \
	ffmpeg \
	-i $CACHE/$FILENAME/$FILENAME.mkv \
	-c:v h264 \
	 $AUDIO_SETTINGS \
	-preset veryslow \
	-crf 20 \
	-c:a aac \
	-b:a 128k \
	-ar 44100 \
	-ac 2 \
	-vf format=$PIXEL_FORMAT \
	-movflags +faststart $SAVEDIR/$FILENAME.mp4 \
	&& \
	cd $CACHE && rm -rf $FILENAME &
}

run() {
	is_recording
	init
	select_area
	fix_area
	with_audio
	select_framerate
	start_record
}

run

exit
