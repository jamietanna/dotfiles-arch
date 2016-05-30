#!/usr/bin/env bash

# TODO rotate _some number_ of entries to make sure we don't lose information if we miss the notification
# TODO show 'new' updates first, then have the 'old' ones? then it reduces cognitive load, and makes it much easier to see how many are new since the last update

CACHED_UPDATE_LIST=/var/run/user/$(id -u)/checkupdates.cache
MAXLINES=1000

if ! curl -s "http://google.com/" 2>&1 > /dev/null;
then
	notify-send "No network" "Cannot check for updates as there is no network"
	exit 1
fi

# prevent diff errors by creating an empty CACHED_UPDATE_LIST if one does not
# already exist
[[ ! -e "$CACHED_UPDATE_LIST" ]] && touch "$CACHED_UPDATE_LIST"

updates="$(checkupdates)"
update_count=$(echo "$updates" | wc -l)
out_str="P"
urgency="normal"
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
	out_str+="p$update_count"
fi

echo "$out_str" > $PANEL_FIFO

update_diffs="$(diff -u$MAXLINES $CACHED_UPDATE_LIST <(echo "$updates"))"
# remove the diff headers
update_diffs="$(echo "$update_diffs" | tail -n+4)"
# ignore any removed entries
update_diffs="$(echo "$update_diffs" | grep --invert-match '^-')"
# remove the leading space from our diff
update_diffs="$(echo "$update_diffs" | sed 's/^ \(.*\)$/\1/')"
# make new entries bold
update_diffs="$(echo "$update_diffs" | sed 's/^+\(.*\)$/<b>\1<\/b>/')"

# if we have specific diffs, display them, otherwise just list all the updates
if [[ -n "$update_diffs" ]];
then
	updates_out="$update_diffs"
else
	updates_out="$(cat $CACHED_UPDATE_LIST)"
fi

if [[ "$1" == "notify" ]];
then
	notify-send -u "$urgency" "$update_count Updates" "$updates_out"
	# update our cached updates list
	# note that we only need to do this when we're displaying it to the user; we
	# want to show the most changes between updates, which can be best achieved
	# by only updating our cached list if we're displaying it to the user
	echo "$updates" > $CACHED_UPDATE_LIST
fi

