#!/usr/bin/env bash

if [[ "TheColonel" -eq "$(hostname") ]];
then
	yay -S nvidia{,-utils,-settings}
fi
