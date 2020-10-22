#!/bin/bash -e

install -m 644 files/oio.service ${ROOTFS_DIR}/etc/systemd/system/oio.service

on_chroot << EOF
cd /home/${FIRST_USER_NAME}
rm -f -r OceanIsOpen
git clone https://github.com/TamataOcean/OceanIsOpen.git
cd /home/${FIRST_USER_NAME}/OceanIsOpen/systools
npm install

#wget https://raw.githubusercontent.com/TamataOcean/OceanIsOpen/serial/systools/oio.service -O /etc/systemd/system/oio.service
systemctl enable oio.service
EOF
