# [[ -e ... ]] vs [[ -f ... ]] because they're going to be symlinks, not regular files
[[ -e $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources
[[ -e $HOME/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -e $HOME/.currbg ]] && feh --bg-fill $HOME/.currbg
xbacklight -set 50
mpc pause

sxhkd &
rofi &

setxkbmap gb &

panel &
exec bspwm
