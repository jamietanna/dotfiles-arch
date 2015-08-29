#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

debug () {
	[[ -n "$DEBUG" ]] && echo -e "\033[93mDebug: $@\033[0m"
}

error () {
	echo -e "\033[91mError: $@\033[0m"
}

banner () {
	echo -e "\033[95m========================================\033[0m"
	echo -e "\033[95m$@\033[0m"
	echo -e "\033[95m========================================\033[0m"
}

if ! which pacaur >/dev/null 2>&1;
then
	error "pacaur cannot be found. Exiting."
	exit 1
fi

for folder in $(find . -maxdepth 1 -type d);
do
	dependencies_path="$folder/dependencies"
	bootstrap_script="$folder/bootstrap.sh"

	# TODO ignore .git through find
	[[ "$folder" == "./.git" || "$folder" == "." ]] && continue

	banner "Unpacking $folder dotfiles"
	./unpack.sh "$folder"

	# skip if we don't have a dependencies file
	if [[ ! -e "$dependencies_path" ]];
	then
		debug "No dependencies file found"
		continue
	else
		REPOS=()
		AUR=()
		. $dependencies_path
		banner "Installing packages\n\tRepos:\t${REPOS[@]}\n\tAUR:\t${AUR[@]}"
		# --needed so we don't reinstall unnecessary pacakges
		pacaur -S "${REPOS[@]} ${AUR[@]}" --needed || error "Error: could not install some packages"
	fi

	# make sure we have the correct dependencies to bootstrap the system
	if [[ -x "$bootstrap_script" ]];
	then
		banner "Running $folder bootstrap script"
		./$bootstrap_script
	fi


	done
