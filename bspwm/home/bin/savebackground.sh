#!/usr/bin/env bash
# vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
# -----------------------------------------------------------------------------
# savebackground.sh
#	Save the current wallpaper in the $SAVED_WALLPAPERS_DIR directory
# -----------------------------------------------------------------------------

# if we have an environment variable already set, prioritise it
SAVED_WALLPAPERS_DIR=${SAVED_WALLPAPERS_DIR:-$HOME/wallpapers/saved}

cd $SAVED_WALLPAPERS_DIR
ln -s "$(readlink -f ~/.currbg)"
