# install.sh
#

echo "Install 'vim', 'mutt', 'msmtp', 'offlineimap', 'w3m', 'eog', 'pass', 'python'"
echo

# email folders
mkdir -p ~/email
chmod 700 ~/email -R
echo "email folders created in ~/email"

# offlineimap
ln -s ~/point/email/offlineimap-rc ~/.offlineimaprc
ln -s ~/point/email/offlineimap.py ~/.offlineimap.py
echo "offlineimap ready"
echo "for automatic syncing, make a cron job"

# msmtp
ln -s ~/point/email/msmtprc ~/.msmtprc
chmod 600 ~/.msmtprc # msmtp requires the config file to be in mod 600 (only me)
echo "msmtp ready"

# mutt
ln -s ~/point/email/mutt-rc ~/.muttrc
ln -s ~/point/email/mutt-mailcap ~/.mutt-mailcap
ln -s ~/point/email/mutt-gmail ~/.mutt-gmail
ln -s ~/point/email/mutt-epitech ~/.mutt-epitech
echo "mutt ready"

echo "done"
