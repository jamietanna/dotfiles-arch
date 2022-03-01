#!/usr/bin/env bash

(
cd ./golang-micropub/ || exit 1
makepkg -si
)
