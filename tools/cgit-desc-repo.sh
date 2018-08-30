#!/bin/bash
#

if [ $# == 0 ]
then
	echo "please give the name of the repo to create"
	exit 1
fi

if [ $# == 1 ]
then
	echo "please give the description for the repo"
	echo "dont forget the double quotes"
	exit 1
fi

if [ $# == 2 ]
then
	ssh vps "cgit-tool desc repos/'$1' '$2'"
	echo "done"
	exit 0
fi
