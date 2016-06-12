[[ -z "$DISPLAY" && $XDG_VTNR -eq 1 ]] && exec startx
systemctl --user import-environment PATH
