#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cmd () {
	echo "CMD: $2"
	if [ "$1" == "home" ];
	then
		$2
	else
		sudo $2
	fi
}

unpack () {
	# PKG home|global
	for f in $(find "$1/$2" -type d);
	do
		full_path="$(readlink -f "$f")"
		path_create="${full_path//$DIR\/$1/}"

		case "$2" in
			home )
			OUT=$HOME
			path_create_final="${path_create//$1\/home/}"
			;;
			global )
			OUT=
			path_create_final="${path_create//$1\/global/}"
			;;
			* )
			echo "ERR"
			exit 1
			;;
		esac
		path_split=(${path_create//\// })

		[ -z "$OUT$path_create_final" ] && continue

		cmd "$2" "mkdir -p $OUT$path_create_final"
	done

	for f in $(find "$1/$2" -type f);
	do
		full_path="$(readlink -f "$f")"
		path_create="${full_path//$DIR\/$1/}"

		case "$2" in
			home )
			OUT=$HOME
			path_create_final="${path_create//$1\/home/}"
			;;
			global )
			OUT=
			path_create_final="${path_create//$1\/global/}"
			;;
			* )
			echo "ERR"
			exit 1
			;;
		esac
		path_split=(${path_create//\// })

		if [ -e "$OUT$path_create_final" ];
		then
			echo "$OUT$path_create_final already exists"
			continue
		fi

		cmd "$2" "ln -s $full_path $OUT$path_create_final"
	done
}

if [ -z "$1" ];
then
	echo "ERROR: Please enter name of package to install"
	exit 1
fi

[ -d "$DIR/$1/home" ] && unpack "$DIR/$1" "home"
	# this one is sudo !!
[ -d "$DIR/$1/global" ] && unpack "$DIR/$1" "global"
