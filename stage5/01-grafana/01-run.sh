#!/bin/bash -e

on_chroot << EOF
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt-get clean 
apt-get update
apt-get install -y grafana
systemctl enable grafana-server

EOF
