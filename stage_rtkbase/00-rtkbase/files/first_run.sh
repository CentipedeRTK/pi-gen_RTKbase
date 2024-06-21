#!/bin/bash

_user="${PWD##*/}"
cd /home/$_user

## install last release
wget https://raw.githubusercontent.com/Stefal/rtkbase/master/tools/install.sh
chmod +x install.sh
sed -i 's/df \"$HOME\"/df \//g' /home/${_user}/install.sh
./install.sh --user ${_user} --dependencies --rtklib --rtkbase-release --gpsd-chrony
find ./ -type f -iname "*.sh" -exec chmod +x {} \;


## install dev branch
#wget https://raw.githubusercontent.com/Stefal/rtkbase/dev/tools/install.sh
#chmod +x install.sh
#sed -i 's/df \"$HOME\"/df \//g' /home/${_user}/install.sh
#./install.sh --user ${_user} --dependencies --rtklib --rtkbase-repo dev --gpsd-chrony
#find ./ -type f -iname "*.sh" -exec chmod +x {} \;

