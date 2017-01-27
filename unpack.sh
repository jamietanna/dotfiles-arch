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

info () {
	echo -e "\033[34mINFO: $@\033[0m"
}

cmd () {
	if [[ -z "$2" ]]; then
		warn "Empty command given. Not executing"
		return
	fi
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

	for f in $(find "$1/$2" -type f);
	do
		cmdstring=""
		full_path="$(readlink -f "$f")"
		path_create="${full_path//$working_dir_path/}"

		case "$2" in
			home )
			path_create_final="${path_create//\/home/$HOME}"
			;;
			global )
			path_create_final="${path_create//\/global/}"
			;;
			* )
			error "invalid unpack location"
			;;
		esac

		# if a config appears for the given machine, unpack it
		# note that the files must named in the format
		# `bin.sh.$(hostname).local`
		# note that we add a special case to not match our zshrc, which is in
		# the format of local resource files. If this check is not here, we
		# will never unpack it!
		if echo $f | grep -q '.*\..*\.local$' && \
			! echo $f | grep -q '/.zshrc.local$';
		then
			if echo $f | grep -q ".*\.$(hostname)\.local\$";
			then
				path_create_final="${path_create_final//$(hostname)\./}"
			else
				info "Not matched $f"
				continue
			fi
		fi

		# unpack systemd files correctly {{{
		# unfortunately we can't symlink the service files into the systemd
		# folder, so we've got to have a single systemd folder, which will then
		# be symlinked

		# only unpack the final folder
		if echo $full_path | grep -q '.config/systemd/user$' && \
			[[ -d "$full_path" ]];
		then
			# make sure that systemd configs aren't stored in other packages
			if ! echo "$1" | grep -q '/systemd$'
			then
				error "Error: Only one folder can store systemd files, stored in the \`systemd\` package"
			else
				# symlink the .config/systemd/user folder to the right
				# directory. note that this the below code will symlink only
				# files, and would otherwise override this functionality
				cmdstring="ln -s $full_path $path_create_final"
				if [[ -e "$path_create_final" ]];
				then
					warn "$path_create_final already exists. Skipping"
					continue
				fi
			fi
		elif echo $full_path | grep -q '.config/systemd/user/'
		then
			# skip the individual files
			continue
		fi
		# }}}

		dir_of_file="$(dirname "$path_create_final")"
		if [[ ! -d "$dir_of_file" ]];
		then
			# if we don't have the directory we require for the file, create it
			info "$dir_of_file doesn't exist, creating it now"
			cmd "$2" "mkdir -p $dir_of_file"
		fi

		if [[ -z "$cmdstring" ]];
		then
			if [[ -f "$f" ]]; then
				if [ -e "$path_create_final" ];
				then
					if [[ -L "$path_create_final" ]]; then
						info "$path_create_final is already symlinked"
					else
						warn "$path_create_final already exists"
					fi
					continue
				fi

				cmdstring="ln -s $full_path $path_create_final"
			fi
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
