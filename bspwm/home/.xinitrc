#!/usr/bin/env bash
[[ -e $HOME/.xinitrc.local ]] && . $HOME/.xinitrc.local

# [[ -e ... ]] vs [[ -f ... ]] because they're going to be symlinks, not regular files
[[ -e $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources
[[ -e $HOME/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -e $HOME/.currbg ]] && feh --bg-fill $HOME/.currbg
xbacklight -set 50
mpc pause

sxhkd &

compton &
# Escape is a much better use than CapsLock, especially as I very rarely use
# all caps anyway. It makes it significantly easier to hit, and means not
# leaving the home row.
setxkbmap -option caps:escape gb &

panel &

exec bspwm
