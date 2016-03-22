#!/usr/bin/env bash

# TODO make these work
# set pipefail
# set errexit

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

debug () {
	[[ -n "$DEBUG" ]] && echo -e "\033[34mDEBUG: " $* "\033[0m"
}

error () {
	echo -e "\033[31mERROR: $@\033[0m" >&2
	exit 1
}

warn () {
	echo -e "\033[33mWARNING: $@\033[0m"
}

cmd () {
	debug "CMD: $2"
	if [ "$1" == "home" ];
	then
		$2
	else
		sudo $2
	fi
}

unpack () {
	# PKG home|global

	# TODO remove hack workaround to make `./` from `./folder` disappear
	working_dir_path="${1//\/.\//\/}"

	for f in $(find "$1/$2");
	do
		full_path="$(readlink -f "$f")"
		path_create="${full_path//$working_dir_path/}"

		case "$2" in
			home )
			path_create_final="${path_create//\/home/$HOME}"
			;;
			global )
			path_create_final="${path_create//\/global/\/}"
			;;
			* )
			error "invalid unpack location"
			;;
		esac

		cmdstring=""
		if [[ -f "$f" ]]; then
			if [ -e "$path_create_final" ];
			then
				warn "$path_create_final already exists"
				continue
			fi

			cmdstring="ln -s $full_path $path_create_final"
		elif [[ -d "$f" ]]; then
			[ -z "$path_create_final" ] && continue

			cmdstring="mkdir -p $path_create_final"
		fi

		cmd "$2" "$cmdstring"

	done
}

if [ -z "$1" ];
then
	error "Please enter name of package to install"
	exit 1
fi

[ -d "$DIR/$1/home" ] && unpack "$DIR/$1" "home"
	# this one is sudo !!
[ -d "$DIR/$1/global" ] && unpack "$DIR/$1" "global"
