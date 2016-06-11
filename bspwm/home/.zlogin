[[ -z "$DISPLAY" && $XDG_VTNR -eq 1 ]] && exec startx
export PATH="$PATH:$HOME/bin"
# make sure we import our custom PATH for any systemd services
systemctl --user import-environment PATH
