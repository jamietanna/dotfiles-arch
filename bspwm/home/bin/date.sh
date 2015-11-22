#!/usr/bin/bash

day=$(date +%d)
cal=$(cal | sed "s/\($day\)/<u>\1<\/u>/g")

notify-send "<b>$(date)</b>\n$cal"
