#!/bin/sh
PANEL_LOCAL_FILE="$HOME/.config/bspwm/bspwm_panel.sh.local"
export PATH="$PATH:$HOME/bin"

export PANEL_FIFO=/tmp/panel-fifo
export PANEL_HEIGHT=24
export PANEL_FONT_FAMILY="LiberationMono:size=08"
export PANEL_WM_NAME="bspwm_panel"
export PANEL_UNDERLINE_HEIGHT=3

if [[ -e "$PANEL_LOCAL_FILE" ]];
then
	. "$PANEL_LOCAL_FILE"
fi
