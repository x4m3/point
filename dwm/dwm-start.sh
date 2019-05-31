#!/bin/bash
#

setxkbmap -layout us,fr,ru -option 'grp:ctrl_alt_toggle' &
nm-applet &
pasystray &
xscreensaver -no-splash &

/home/x4m3/point/dwm/dwm-status.sh &

exec dwm 2> ~/.dwm.log
