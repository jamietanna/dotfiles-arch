#!/usr/bin/env bash

if ! curl -s "http://google.com/" 2>&1 > /dev/null;
then
	notify-send "No network" "Cannot check for updates as there is no network"
	exit 1
fi

updates="$(checkupdates)"
update_count=$(echo "$updates" | wc -l)
out_str="P"
if [[ "$update_count" -eq "0" || -z "$updates" ]];
then
	out_str+=""
	update_count=0
# only match the full `linux` package, not things like `linux-firmware`
elif echo "$updates" | grep "^linux " >/dev/null;
then
	urgency="critical"
	out_str+="k$update_count"
else
	urgency="normal"
	out_str+="p$update_count"
fi

echo "$out_str" > $PANEL_FIFO

if [[ "$1" == "notify" ]];
then
	notify-send -u "$urgency" "$update_count Updates" "$updates"
fi

