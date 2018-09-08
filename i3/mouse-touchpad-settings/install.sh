sudo pacman -S libinput xf86-input-libinput xorg-xinput
echo "copying configuration files to '/etc/X11/xorg.conf.d/'";
sudo cp 30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf;
sudo cp 80-any-pointer-mouse.conf /etc/X11/xorg.conf.d/80-any-pointer-mouse.conf;
echo "done";
