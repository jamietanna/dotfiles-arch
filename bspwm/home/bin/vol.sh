#!/bin/bash

DEVICE=IEC958

get_volume () {
	# http://unix.stackexchange.com/a/89583
	VOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget $DEVICE))
	SOUND_ON=$(awk -F"[][]" '/dB/ { print $6 }' <(amixer sget $DEVICE))
	if [ "$SOUND_ON" == "off" ];
	then
		VOL=0
	fi
	echo "${VOL//%/}"
}

case "$1" in
	up )
		$AMIXER -q sset $DEVICE 5%+
		$AMIXER -q sset $DEVICE unmute
		;;
	down )
		$AMIXER -q sset $DEVICE 5%-
		$AMIXER -q sset $DEVICE unmute
		;;
	toggle )
		amixer -q sset $DEVICE toggle
		;;
	get )
		get_volume
		exit 0
		;;
	* )
		exit 1
		;;
esac
[ -e "$PANEL_FIFO" ] && echo "V$(get_volume)" > $PANEL_FIFO
