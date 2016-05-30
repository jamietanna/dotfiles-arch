#!/bin/sh
PANEL_LOCAL_FILE="/etc/profile.d/bspwm_panel.sh.local"
export PATH="$PATH:/usr/local/bin/panel"

export PANEL_FIFO=/tmp/panel-fifo
export PANEL_HEIGHT=24
export PANEL_FONT_FAMILY="LiberationMono:size=11"

if [[ -e "$PANEL_LOCAL_FILE" ]];
then
	. "$PANEL_LOCAL_FILE"
fi
