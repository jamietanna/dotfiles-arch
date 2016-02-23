#!/usr/bin/bash

day=$(date +%e)
cal=$(cal | sed "s/\($day\)/<u>\1<\/u>/g")

notify-send "$(date)" "$cal"
