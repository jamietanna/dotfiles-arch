#!/usr/bin/env bash
# vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
# -----------------------------------------------------------------------------
# changebackground.sh
#	Change the background for the current session to that of the first argument
# -----------------------------------------------------------------------------

set -e

if [[ -z "$1" ]];
then
	echo "Error: Need to provide the filename to change the background to"
	exit 1
fi

fullfile=$(readlink -f "$1")
dir=$(dirname "$fullfile")
filename=$(basename "$fullfile")
filename="${filename%.*}"

png_filepath="${dir}/${filename}.png"

# don't reconvert if we've already used this background before!
if [[ ! -e "$png_filepath" ]]; then
	echo "$png_filepath does not exist. Creating."
	convert "$fullfile" "$png_filepath"
fi

ln -sf "$(readlink -f "$png_filepath")" $HOME/.currbg
feh --bg-fill $HOME/.currbg
