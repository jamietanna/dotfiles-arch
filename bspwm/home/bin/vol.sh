#!/bin/bash

AMIXER_CMD="amixer -c 0"
DEVICE=Master

get_volume () {
	# http://unix.stackexchange.com/a/89583
	VOL=$(awk -F"[][]" '/dB/ { print $2 }' <($AMIXER_CMD sget $AMIXER_DEVICE))
	SOUND_ON=$(awk -F"[][]" '/dB/ { print $6 }' <($AMIXER_CMD sget $AMIXER_DEVICE))
	if [ "$SOUND_ON" == "off" ];
	then
		VOL=0
	fi
	echo "${VOL//%/}"
}

mute () {
	do_mute "true"
}

unmute () {
	do_mute "false"
}

toggle () {
	do_mute "toggle"
}

do_mute () {
	pactl set-sink-mute $SINK_NUMBER "$1"
}

case "$1" in
	up )
		$AMIXER_CMD -q sset $AMIXER_DEVICE 5%+
		unmute
		;;
	down )
		$AMIXER_CMD -q sset $AMIXER_DEVICE 5%-
		unmute
		;;
	toggle )
		toggle
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
