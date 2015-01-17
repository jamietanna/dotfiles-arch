#!/bin/bash

get_volume () {
	# http://unix.stackexchange.com/a/89583
	VOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master))
	SOUND_ON=$(awk -F"[][]" '/dB/ { print $6 }' <(amixer sget Master))
	if [ "$SOUND_ON" == "off" ];
	then
		VOL=0
	fi
	echo "${VOL//%/}"
}

case "$1" in
	up )
		amixer -q sset Master 5%+
		;;
	down )
		amixer -q sset Master 5%-
		;;
	toggle )
		amixer -q sset Master toggle
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
