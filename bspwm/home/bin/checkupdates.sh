#!/usr/bin/env bash

updates="$(checkupdates)"
update_count=$(echo "$updates" | wc -l)
out_str="P"
if [[ "$update_count" -eq "0" || -z "$updates" ]];
then
	out_str+=""
	update_count=0
# only match the full `linux` package, not things like `linux-firmware`
elif [[ "${updates//$'\n'/|}" == *"|linux|"* ]];
then
	out_str+="k$update_count"
else
	out_str+="p$update_count"
fi

# always update our current count
echo "$out_str" > $PANEL_FIFO

# but only popup if the user wants it
if [[ "$1" == "notify" ]];
then
	notify-send "<b>$update_count Updates</b>\n$updates"
fi

