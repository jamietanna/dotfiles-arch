[[ -e $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources
[[ -e $HOME/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -e $HOME/.currbg ]] && feh --bg-fill $HOME/.currbg
xbacklight -set 50
mpc pause

sxhkd &

setxkbmap gb &

panel &
exec bspwm
