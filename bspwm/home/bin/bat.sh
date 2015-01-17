#!/bin/bash

DATA=$(acpi -b)

remainder=$(echo $DATA | cut -d" " -f5)
percent=$(echo $DATA | cut -d" " -f4 | sed 's/,//g')

echo $DATA | grep "Discharging" > /dev/null
if [ $? -eq 0 ];
then
	echo "$percent $remainder"
else
	echo "$percent +$remainder"
fi

