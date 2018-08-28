sudo pacman -S libinput xf86-input-libinput xorg-xinput
echo "copying the configuration file to '/etc/X11/xorg.conf.d/20-natural-scrolling.conf'";
sudo cp 20-natural-scrolling.conf /etc/X11/xorg.conf.d/20-natural-scrolling.conf;
echo "done";
