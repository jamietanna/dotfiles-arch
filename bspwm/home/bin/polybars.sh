#!/usr/bin/env bash

for mon in $(polybar -m | cut -f1 -d:); do
	polybar -r $(cut -f1 -d: <<< "$mon") &
done
