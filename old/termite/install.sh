#!/bin/bash
#

echo "rm ~/.config/termite"
rm -rf ~/.config/termite

echo "mkdir ~/.config/termite"
mkdir -p ~/.config/termite

echo "ln config file"
ln -s /home/x4m3/point/termite/config ~/.config/termite/config

echo "done"
