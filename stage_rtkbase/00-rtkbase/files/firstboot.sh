#!/bin/bash

cd /home/basegnss/rtkbase/tools && \
sudo ./install.sh --user basegnss --unit-files --detect-modem --detect-gnss --configure-gnss --start-services
sudo rm /lib/systemd/system/firstboot.service

