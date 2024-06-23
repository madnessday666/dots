#!bin/bash

BT_STATUS=$(echo $(bluetoothctl show) | awk '{print $14}')
BLUE='#0293db'

if [ "$BT_STATUS" = "yes" ]; then
	echo "%{F$BLUE}BT%{F-}"
else
	echo "BT"
fi
