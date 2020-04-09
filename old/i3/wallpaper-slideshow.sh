#!/bin/bash
#

# folder with wallpapers
FOLDER="$HOME/yadisk/wallpapers/"

# time interval in minutes
TIME=5

while true
do
	for f in $FOLDER/*
	do
		`exec feh --bg-fill "$f"`
		sleep $[ $TIME*60 ]
	done
done
