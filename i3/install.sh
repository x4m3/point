#!/bin/bash
#

mkdir -p ~/.config/i3/

echo "removing old config";
rm ~/.config/i3/config

ln -s ~/point/i3/config ~/.config/i3/config

echo "config ready";
echo "restart i3 (*mod + shift + r* if you're just updating the config)";
echo "";
echo "wallpaper is at ~/.wallpaper.jpg";
echo "check the file *requirements.txt* to see what to install (most is for arch)";
