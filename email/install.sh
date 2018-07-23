# install.sh
#

echo "Install 'vim', 'mutt', 'msmtp', 'offlineimap', 'w3m', 'eog', 'pass', 'python'"
echo

# email folders
mkdir -p ~/email
mkdir -p ~/email/gmail
chmod 700 ~/email -R
echo "email folders created in ~/email"

# offlineimap
ln -s ~/point/email/offlineimap-rc ~/.offlineimaprc
ln -s ~/point/email/offlineimap.py ~/.offlineimap.py
echo "offlineimap ready"
systemctl enable --user offlineimap.service
systemctl start --user offlineimap.service
echo "offlineimap enabled and started with systemd"

# msmtp
ln -s ~/point/email/msmtprc ~/.msmtprc
chmod 600 ~/.msmtprc # msmtp requires the config file to be in mod 600 (only me)
echo "msmtp ready"

# mutt
ln -s ~/point/email/mutt-rc ~/.muttrc
ln -s ~/point/email/mutt-mailcap ~/.mutt-mailcap
echo "mutt ready"

echo "done"
