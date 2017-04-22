#!/bin/bash

. $HOME/.config/bspwm/bspwm_panel.sh

get_volume () {
	status=$(pulseaudio-ctl full-status)
	if [[ "$(echo "$status" | cut -d' ' -f2)" == "yes" ]];
	then
		echo "0"
	else
		echo "$(echo "$status" | cut -d' ' -f1)"
	fi
}

toggle () {
	pulseaudio-ctl mute
}

inc () {
	pulseaudio-ctl up
}

dec () {
	pulseaudio-ctl down
}

case "$1" in
	up )
		inc
		;;
	down )
		dec
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
