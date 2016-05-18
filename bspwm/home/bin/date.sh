#!/usr/bin/bash

day=$(date +%e)
cal=$(cal | sed "s/\( *\)\($day\)\( *\)/\1<u>\2<\/u>\3/g")

notify-send -u low "$(date)" "$cal"
