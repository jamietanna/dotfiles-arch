#!/usr/bin/env bash
# use a symbol to conditionally load the machine-specific resources file, if one
# exists
# TODO make this actually work! need some output IF it exists
exists_flag=""
if [[ -e ~/.Xresources.local ]];
then
	exists_flag="-DLOCAL_EXISTS='exists'"
fi
xrdb "$exists_flag" ~/.Xresources
