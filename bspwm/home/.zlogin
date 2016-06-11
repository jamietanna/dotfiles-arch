[[ -z "$DISPLAY" && $XDG_VTNR -eq 1 ]] && exec startx
export PATH="$PATH:$HOME/bin"
