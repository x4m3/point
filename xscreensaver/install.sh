#!/bin/bash
#

echo "removing ~/.xscreensaver"
rm ~/.xscreensaver

echo "installing new config"
ln -s ~/point/xscreensaver/config ~/.xscreensaver

echo "done"
