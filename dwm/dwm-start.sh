#!/bin/bash
#

nm-applet &
pasystray &
xscreensaver -no-splash &

/home/x4m3/point/dwm/dwm-status.sh &

exec dwm 2> ~/.dwm.log
