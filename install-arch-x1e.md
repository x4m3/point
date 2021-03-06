# arch install x1 extreme

## network

`ping epi.today`

`wifi-menu` to connect to a wireless network

## partitions

layout:

1. efi (1gb)
2. windows (493gb)
3. lvm

### create encrypted container

- cryptsetup -v luksFormat --type luks2 -s 512 -h sha512 <lvm>
- cryptsetup open <lvm> enc

### create lvm2 partition and partitions

- pvcreate /dev/mapper/enc
- vgcreate arch /dev/mapper/enc
- lvcreate -L 40G arch -n swap
- lvcreate -l 100%FREE arch -n root
- lvdisplay # to check
- mkswap /dev/arch/swap
- mkfs.btrfs /dev/arch/root

### mount partitions

- swapon /dev/arch/swap
- mount /dev/arch/root /mnt
- mkdir /mnt/boot
- mount <efi> /mnt/boot

## installing base

- `vim /etc/pacman.d/mirrorlist` -> add mirror.x4m3.rocks
- pacstrap -i /mnt base base-devel

## start configuring new system

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

- pacman -S btrfs-progs lvm2
- pacman -S linux linux-lts linux-headers linux-lts-headers intel-ucode linux-firmware
- pacman -S vim openssh git pass pass-otp man man-db man-pages
- pacman -S networkmanager wpa_supplicant wireless_tools netctl dialog

systemctl enable NetworkManager

## locales and time

- vim /etc/locale.gen (en, fr, ru)
- locale-gen
- vim /etc/locale.conf -> LANG=en_US.UTF-8
- vim /etc/vconsole.conf -> KEYMAP=us
- ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
- hwclock -w -u

## hostname and users

vim /etc/hostname -> x1e

- passwd
- useradd -m -G wheel phil
- passwd phil

- EDITOR=vim visudo
`# %wheel ALL=(ALL) ALL`

## kernel and bootloader

### kernel

vim /etc/mkinitcpio.conf
```
MODULES=(battery)
HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt sd-lvm2 filesystems fsck)
```
mkinitcpio -P

### bootloader (systemd-boot)

bootctl install

vim /loader/loader.conf
```
defaut arch.conf
timeout 5
editor no
console-mode max
```

vim /loader/entries/arch.conf
```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options rd.luks.uuid=ABC root=/dev/arch/root resume=/dev/arch/swap rw quiet loglevel=3
```

in vim: `:read ! blkid /dev/lvm_partition` replace ABC with the UUID of the partition

repeat for LTS kernel

## reboot onto the new system

- exit chroot
- umount -R /mnt
- reboot

## first startup

- sudo pacman -S libinput
- sudo pacman -S xf86-video-intel mesa acpi_call nvidia nvidia-utils
- sudo pacman -S gnome gnome-extra gnome-tweaks seahorse gthumb gnome-software-packagekit-plugin
- sudo systemctl enable gdm.service
- sudo pacman -S code ttf-opensans noto-fonts-emoji ntfs-3g
- sudo pacman -S flatpak

## reboot and start gnome

## install flatpak apps
- sudo flatpak install flathub org.mozilla.firefox
- sudo flatpak install flathub org.telegram.desktop
- sudo flatpak install flathub com.spotify.Client

## install yay

- git clone https://aur.archlinux.org/yay.git
- cd yay
- makepkg -si

## install menlo font

download package from mirror.x4m3.rocks

install with `sudo pacman -U <file>`

## install yandex-disk and start syncing

- yay yandex-disk
- systemctl --user enable yandex-disk.service

## download passwords and point configuration

### dot files

clone the git repo

### pgp key & gpg-gent

setup pgp key, install gpg configuration

to unlock pgp key automatically:

in `~/.gnupg/gpg-agent.conf` put: `pinentry-program /usr/bin/pinentry-gnome3`

and restart to make sure it works correctly.

## gnome extensions

sudo pacman -S chrome-gnome-shell

- [netspeed](https://extensions.gnome.org/extension/104/netspeed/)
- [tray-icons](https://extensions.gnome.org/extension/1503/tray-icons/)
- [emoji-selector](https://extensions.gnome.org/extension/1162/emoji-selector/)

## firefox configuration

- restore previous session
- disable ctrl+tab recent order
- enable containers and setup 

- [Gnome Shell Integration](https://extensions.gnome.org)
- [PassFF](https://addons.mozilla.org/firefox/addon/passff) and install the [Host app](https://github.com/passff/passff-host)
- [Facebook container](https://addons.mozilla.org/firefox/addon/facebook-container)
- [Old reddit redirect](https://addons.mozilla.org/firefox/addon/old-reddit-redirect)

## play videos in gnome videos (totem)

sudo pacman -S gst-libav

## trackpad configuration

**!! Only on Xorg !!** on Wayland no need to do anything

sudo pacman -S xorg-xinput xf86-input-libinput

trackpad settings can be configured in gnome settings.

## bluetooth

- sudo pacman -S bluez bluez-utils
- sudo systemctl enable bluetooth

## battery

by default the battery stats are not good, add the `battery` module in mkinitcpio

## brightness

by default the brightness keys don't do anything.

there is a way to enable changing the brightness, but it's buggy.

run as root: `echo "options i915 enable_dpcd_backlight=1" >> /etc/modprobe.d/i915.conf`

**note**: apparently the issues should be fixed in kernel 5.7, more info here: [gitlab issue of intel drivers](https://gitlab.freedesktop.org/drm/intel/-/issues/510)

## fingerprint

Check ArchWiki section [Fingerprint](https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Extreme_(Gen_2)#Fingerprint)

- sudo pacman -S fprintd
- `fwupdmgr get-devices` and check that "Prometheus" appears
- `fwupdmgr update` to install update for finerprint device
- reboot
- wait for `systemctl status fprintd.service` to report as `inactive`
- in gnome settings in users section setup fingerprint login

## fwupd (firmware updates)

sudo pacman -S fwupd gnome-firmware

firmware updates will show up in `gnome-software`, you can view supported firmwares in `gnome-firmware`

## card reader

**TODO**

## webcam autounlock

**TODO**

## gpu

intel and nvidia.

hdmi and usb-c output is possible only with the nvidia gpu

### setup gpu switching

start by installing `optimus-manager` and `optimus-manager-qt` from the AUR and reboot. instal `gdm-prime` from the AUR to have gdm with gpu switching.

edit the file `/etc/gdm/custom.conf` and uncomment the line `#WaylandEnable=false` to disable wayland for gdm, and reboot.

start gnome normally and check in the settings in about section that you are on intel graphics. open the optimus-manager application and in the settings set to open on startup.

in the applet switch to nvidia. it will log you out.

if you get stuck, simply switch to another tty and back to tty1 and wait a couple of seconds. you should be greated with gdm.

login again and check in the setttings that you are on nvidia graphics.

repeat the same process to switch back to intel.

