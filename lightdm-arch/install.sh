#!/bin/bash
#

echo "installing packages"
sudo pacman -S lightdm lightdm-gtk-greeter accountsservice

echo "copying needed files"
sudo cp user-icon.png /var/lib/AccountsService/icons/x4m3.png

echo "backing up old configuration"
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.orig
sudo cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf.orig

echo "copying new configuration"
sudo cp lightdm.conf /etc/lightdm/lightdm.conf
sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf

echo "adding lightdm to startup"
sudo systemctl enable lightdm.service

echo
echo "optional package: lightdm-gtk-greeter-settings"
echo "done"
