#!/bin/bash

get_volume () {
	pulseaudio-ctl full-status | cut -f1 -d' '
}

toggle () {
	pulseaudio-ctl mute
}

case "$1" in
	up )
		pulseaudio-ctl up
		;;
	down )
		pulseaudio-ctl down
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
