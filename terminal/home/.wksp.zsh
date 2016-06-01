#!/usr/bin/env zsh
# vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
# -----------------------------------------------------------------------------
# .wksp.zsh
# 	TODO
# -----------------------------------------------------------------------------
# Location: $HOME/.wksp
# -----------------------------------------------------------------------------
WORKSPACE_ROOT="$HOME/workspaces"

function wksp () {
	# given an argument, cd into that workspace
	# if the argument is '.', go to the root of our workspace
	workspace_location="$WORKSPACE_ROOT/$1"

	if [[ -z "$1" ]];
	then
		>&2 echo -e "\033[91mERROR: No workspace name given\033[0m"
		echo "$WORKSPACE_ROOT"
		return 1
	fi

	if [[ "$1" == "." ]];
	then
		workspace_location="$WORKSPACE_ROOT/$(get_workspace_name)"
	fi

	if [[ ! -e "$workspace_location" ]];
	then
		echo -e "\033[93mWorkspace \`$1\` does not exist. Creating now...\033[0m"
		mkdir -p "$workspace_location"
	fi

	cd "$workspace_location"
}

# display a different prompt when we're inside our workspaces - namely one that
# doesn't include the full workspace path

function get_workspace_path () {
	local curr_path
	local workspace_path
	curr_path="$(pwd)"
	if [[ "$curr_path" == "$WORKSPACE_ROOT" ]];
	then
		echo "(root)"
		return
	fi
	workspace_path="${curr_path//${WORKSPACE_ROOT}\//}"
	echo "${workspace_path}"
}

function get_workspace_path_short () {
	local workspace_path
	local workspace_name
	local workspace_path_short
	workspace_path="$(get_workspace_path)"
	workspace_name="$(echo ${workspace_path} | sed 's/\([^/]*\).*/\1/g')"
	workspace_path_short="${workspace_path/${workspace_name}\//}"
	echo "${workspace_path_short}"
}

function get_workspace_name () {
	local workspace_path
	local workspace_name
	workspace_path="$(get_workspace_path)"
	workspace_name="$(echo ${workspace_path} | sed 's/\([^/]*\).*/\1/g')"
	echo "${workspace_name}"
}

function workspace_prompt () {
	if str_contains "$(pwd)" "${WORKSPACE_ROOT}";
	then
		local workspace_name
		workspace_name="$(get_workspace_name)"
		REPLY="W:$workspace_name "
	else
		REPLY=""
	fi
}

function path_wksp_prompt () {
	local workspace_name
	local workspace_path

	if str_contains "$(pwd)" "${WORKSPACE_ROOT}";
	then
		workspace_path="$(get_workspace_path)"
		workspace_name="$(get_workspace_name)"
		if [[ "$workspace_path" == "$workspace_name" ]];
		then
			# if we're at the top of the workspace, then don't output where we are
			# as we'll already have `W:<wksp>` displayed
			REPLY=""
		else
			# otherwise, display the path, ignoring the workspace name, for 40 characters,
			# taking care to truncate with a '..' if over that length
			REPLY="%40<..<$(get_workspace_path_short)%<< "
		fi
		# REPLY="${workspace_path} "

		# REPLY="%40<..<%~%<< "
	else
		REPLY="%40<..<%~%<< "
	fi
}

# http://unix.stackexchange.com/a/65071
compdef '_path_files -/ -W $WORKSPACE_ROOT' wksp
