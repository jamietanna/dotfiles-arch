#!/usr/bin/env bash

. $HOME/.config/bspwm/bspwm_panel.sh

current_status () {
	echo -n "M"

	mpc_status="$(mpc status)"

	if echo "$mpc_status" | grep "playing" 2>&1 > /dev/null;
	then
		echo -n "pl"
	elif echo "$mpc_status" | grep "paused" 2>&1 > /dev/null;
	then
		echo -n "pa"
	else
		echo -n "st"
		echo
		return
	fi

	mpc current
}

# If mpd isn't running, don't do anything
if ! mpc version >/dev/null 2>&1; then
	exit 1
fi

case $1 in
	"toggle"|"play"|"pause"|"prev"|"next"|"status"|"current" )
		mpc $1 >/dev/null 2>&1
		current_status > "$PANEL_FIFO"
		;;
	* )
		exit 1
		;;
esac
