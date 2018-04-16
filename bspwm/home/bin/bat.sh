#!/bin/bash

. $HOME/.Xresourceshelper
DATA=$(acpi -b)

remainder=$(echo $DATA | cut -d" " -f5)
percent=$(echo $DATA | cut -d" " -f4 | sed 's/,//g')

output_str=""
if grep -q "Discharging" <<< "$DATA";
then
	percent_int="$(sed 's/%//' <<< "$percent")"
	hours="$(cut -f1 -d: <<< "$remainder")"
	minutes="$(cut -f2 -d: <<< "$remainder")"
	if [[ "$percent_int" -le 10 ]] || [[ "$hours" -eq 0 && "$minutes" -le 30 ]]; then
		output_str+="%{B$(colour_from_xresources col_red)}%{F$(colour_from_xresources col_white)}"
	elif [[ "$percent_int" -le 30 ]] || [[ "$hours" -eq 0 ]]; then
		output_str+="%{F$(colour_from_xresources col_red)}"
	fi
	output_str+="${percent} $remainder"
else
	output_str+="${percent} +$remainder"
fi

echo "$output_str%{F-}%{B-}"
