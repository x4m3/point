#!/bin/bash

FOLDER=$1

if [ "$FOLDER" == "" ] ; then
	echo "gimme a folder to put the config file plz"
	exit 1;
fi

if cd $FOLDER; then
	echo "copying config file";
	cp config $FOLDER;
else
	echo "gimme a folder to put the config file plz"
	exit 1;
fi

echo "";
echo "dependecies used";
echo "pactl feh rofi light-git(aur) imgur-screenshot-git(aur)";
