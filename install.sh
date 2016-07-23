#!/bin/bash

FOLDER=$1

if cd $FOLDER; then
	echo "copying config file";
	cp config $FOLDER;
else
	echo "gimme a folder to put the config file plz"
	exit 1;
fi

if [ "$FOLDER" == "" ] ; then
	echo "gimme a folder to put the config file plz"
	exit 1;
fi

echo "dependecies used"
echo "pactl feh"

