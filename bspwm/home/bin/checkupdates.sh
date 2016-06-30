#!/usr/bin/env bash

# TODO rotate _some number_ of entries to make sure we don't lose information if we miss the notification
# TODO show 'new' updates first, then have the 'old' ones? then it reduces cognitive load, and makes it much easier to see how many are new since the last update

CACHED_CORE_UPDATE_LIST=/var/run/user/$(id -u)/checkupdates.cache
CACHED_AUR_UPDATE_LIST=/var/run/user/$(id -u)/checkupdates.aur.cache
MAXLINES=1000

if ! curl -s "http://google.com/" > /dev/null 2>&1;
then
	notify-send "No network" "Cannot check for updates as there is no network"
	exit 1
fi

# prevent diff errors by creating an empty CACHED_UPDATE_LIST if one does not
# already exist
[[ ! -e "$CACHED_CORE_UPDATE_LIST" ]] && touch "$CACHED_CORE_UPDATE_LIST"
[[ ! -e "$CACHED_AUR_UPDATE_LIST" ]] && touch "$CACHED_AUR_UPDATE_LIST"

core_updates="$(checkupdates)"
core_update_count=$(echo "$core_updates" | wc -l)
# cower returns a non-zero status code if there are updates
aur_updates="$(cower -u || true)"
aur_updates="${aur_updates//:: /}"
aur_update_count=$(echo "$aur_updates" | wc -l)

total_update_count="$((core_update_count + aur_update_count))"

out_str="P"
urgency="normal"
if [[ "$total_update_count" -eq "0" || (-z "$core_updates" && -z "$aur_updates") ]];
then
	out_str+=""
	total_update_count=0
# only match the full `linux` package, not things like `linux-firmware`
elif echo "$core_updates" | grep "^linux " >/dev/null;
then
	urgency="critical"
	out_str+="k$total_update_count"
else
	out_str+="p$total_update_count"
fi

echo "$out_str" > "$PANEL_FIFO"

core_update_diffs="$(diff -u$MAXLINES "$CACHED_CORE_UPDATE_LIST" <(echo "$core_updates"))"
# remove the diff headers
core_update_diffs="$(echo "$core_update_diffs" | tail -n+4)"
# ignore any removed entries
core_update_diffs="$(echo "$core_update_diffs" | grep --invert-match '^-')"
# remove the leading space from our diff
core_update_diffs="$(echo "$core_update_diffs" | sed 's/^ \(.*\)$/\1/')"
# make new entries bold
core_update_diffs="$(echo "$core_update_diffs" | sed 's/^+\(.*\)$/<b>\1<\/b>/')"

aur_update_diffs="$(diff -u$MAXLINES "$CACHED_AUR_UPDATE_LIST" <(echo "$aur_updates"))"
# remove the diff headers
aur_update_diffs="$(echo "$aur_update_diffs" | tail -n+4)"
# ignore any removed entries
aur_update_diffs="$(echo "$aur_update_diffs" | grep --invert-match '^-')"
# remove the leading space from our diff
aur_update_diffs="$(echo "$aur_update_diffs" | sed 's/^ \(.*\)$/\1/')"
# make new entries bold
aur_update_diffs="$(echo "$aur_update_diffs" | sed 's/^+\(.*\)$/<b>\1<\/b>/')"

# if we have specific diffs, display them, otherwise just list all the updates
updates_out=""
if [[ -n "$core_update_diffs" ]];
then
	updates_out+="$core_update_diffs"
else
	updates_out+="$(cat "$CACHED_CORE_UPDATE_LIST")"
fi

[[ -n "$updates_out" ]] && updates_out+="\n\n"

if [[ -n "$aur_update_diffs" ]];
then
	updates_out+="$aur_update_diffs"
else
	updates_out+="$(cat "$CACHED_AUR_UPDATE_LIST")"
fi

if [[ "$1" == "notify" ]];
then
	notify-send -u "$urgency" "${core_update_count}+${aur_update_count} Updates" "$updates_out"
	# update our cached updates list
	# note that we only need to do this when we're displaying it to the user; we
	# want to show the most changes between updates, which can be best achieved
	# by only updating our cached list if we're displaying it to the user
	echo "$core_updates" > "$CACHED_CORE_UPDATE_LIST"
	echo "$aur_updates" > "$CACHED_AUR_UPDATE_LIST"
fi

