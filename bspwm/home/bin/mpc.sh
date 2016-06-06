#!/usr/bin/env bash

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
	fi

	mpc current
}

case $1 in
	"toggle"|"play"|"pause"|"prev"|"next"|"status"|"current" )
		mpc $1 >/dev/null 2>&1
		current_status > "$PANEL_FIFO"
	;;
esac
