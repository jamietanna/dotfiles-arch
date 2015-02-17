[[ -e $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources
[[ -e $HOME/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -e $HOME/.currbg ]] && feh --bg-fill $HOME/.currbg

sxhkd &
panel &
exec bspwm
