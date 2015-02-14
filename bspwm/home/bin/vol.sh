#!/bin/bash

AMIXER="amixer -c 1"
DEVICE=Master

get_volume () {
	# http://unix.stackexchange.com/a/89583
	VOL=$(awk -F"[][]" '/dB/ { print $2 }' <($AMIXER sget $DEVICE))
	SOUND_ON=$(awk -F"[][]" '/dB/ { print $6 }' <($AMIXER sget $DEVICE))
	if [ "$SOUND_ON" == "off" ];
	then
		VOL=0
	fi
	echo "${VOL//%/}"
}

case "$1" in
	up )
		$AMIXER -q sset $DEVICE 5%+
		;;
	down )
		$AMIXER -q sset $DEVICE 5%-
		;;
	toggle )
		$AMIXER -q sset $DEVICE toggle
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
