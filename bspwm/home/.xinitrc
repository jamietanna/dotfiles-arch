# [[ -e ... ]] vs [[ -f ... ]] because they're going to be symlinks, not regular files
[[ -e $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources
[[ -e $HOME/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -e $HOME/.currbg ]] && feh --bg-fill $HOME/.currbg

sxhkd &
panel &
exec bspwm
