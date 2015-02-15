[[ -e $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources
[[ -e $HOME/.Xmodmap ]] && xmodmap ~/.Xmodmap

sxhkd &
panel &
exec bspwm
