#!/bin/bash
#

if [ $# == 0 ]
then
	echo "please give the name of the repo to create"
	exit 1
fi

if [ $# == 1 ]
then
	ssh vps "cgit-tool new repos/'$1' && cgit-tool owner repos/'$1' 'Philippe Loctaux'"
	echo "done"
	exit 0
fi
