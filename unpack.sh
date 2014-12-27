#!/bin/bash

newdot () {
	mkdir -p $1/{home,global}
}

err () {
	echo -e "\033[91m$@\033[0m"
}

unpack () {
	# unpack dir isGlobal
	if [ -d "$1" ];
	then
		dir_old=$(pwd)
		cd "$1"
		if ! $2;
		then
			stow -t "$HOME" . 
		else
			sudo stow -t / .
		fi
		cd "$dir_old"
	fi
}

if ! which stow > /dev/null 2>&1;
then
	err "Error: GNU stow is not installed, cannot continue"
	exit 1
fi

# TODO: need to only check for $1's from the executing dir (SO 59895)
while test ${#} -gt 0
do
	if [ ! -d "$1" ];
	then
		err "$1 does not exist, skipping..."
	else
		unpack "$1/home" false
		unpack "$1/global" true 
	fi
	shift
done
