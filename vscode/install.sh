#!/bin/bash
#

# make the directory in case it doesnt exist yet
mkdir -p ~/.config/Code/User/

# link the settings file
ln -s ~/point/vscode/settings.json ~/.config/Code/User

echo "done"