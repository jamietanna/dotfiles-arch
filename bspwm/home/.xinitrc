[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

sxhkd &
panel &
exec bspwm
