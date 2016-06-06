#!/bin/bash
DELIM=';'

function ip_from_iface() {
	# http://unix.stackexchange.com/a/87470
	ip addr show $1 | grep -Po 'inet \K[\d.]+'
}

function get_iface_status() {
	# $1: /sys/class/net/...
	iface_path="$1"
	local iface=$(basename $iface_path)
	local outputstr=""
	local tag=""
	local ip=""

	local operstate=$(cat $iface_path/operstate)
	if [ "$operstate" == "up" ];
	then
		ip="$(ip_from_iface "$iface")"
		tag="C"
	else
		tag="D"
	fi

	# a triple, _without_ brackets; they complicate the parsing process and
	# don't really add anything
	echo -n "${tag},${iface},${ip}"
}

output=""
for iface_path in /sys/class/net/*;
do
	iface=$(basename $iface_path)
	# ignore the loopback and virtualbox interfaces
	if echo "$iface" | grep -qP '^(lo|vboxnet.*)$'
	then
		continue
	fi

	output+="$(get_iface_status $iface_path)${DELIM}"
done
echo "X$output"
