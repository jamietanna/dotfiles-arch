#!/usr/bin/env bash
# vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
# -----------------------------------------------------------------------------
# rotatebackground.sh
#	Randomly select a new background from the wallpapers directory, and set it
#	as the new background
# -----------------------------------------------------------------------------

# if we have an environment variable already set, prioritise it
WALLPAPERS_DIR=${WALLPAPERS_DIR:-$HOME/wallpapers}

wallpaper="$(find $WALLPAPERS_DIR -maxdepth 1 -type f | shuf | head -n1)"
changebackground.sh "$wallpaper"
