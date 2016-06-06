#!/bin/bash
tag=""
output=""
for iface_path in /sys/class/net/*;
do
	iface=$(basename $iface_path)
    # ignore the loopback and virtualbox interfaces
    if echo "$iface" | grep -qP '^(lo|vboxnet.*)$'
    then
        continue
    fi

	if [ -n "$output" ];
	then
		output="$output $iface"
	else
		output="$output$iface"
	fi

	# if a single connection is valid, that's enough
	[ "$tag" != "" ] && continue

	# use sysfs' information to find out whether we're connected or not
	operstate=$(cat $iface_path/operstate)
	if [ "$operstate" == "up" ];
	then
		tag="XC"
	else
		tag="XD"
	fi
done
echo "$tag$output"
