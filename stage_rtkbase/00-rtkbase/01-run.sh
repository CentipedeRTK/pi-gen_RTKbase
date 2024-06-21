#!/bin/bash -e

install -m 644 files/first_run.sh ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/
install -m 644 files/firstboot.service ${ROOTFS_DIR}/lib/systemd/system/
install -m 644 files/firstboot.sh ${ROOTFS_DIR}/boot/

on_chroot << EOF
cd /etc/systemd/system/multi-user.target.wants && ln -s /lib/systemd/system/firstboot.service
cd /home/${FIRST_USER_NAME}
find ./ -type f -iname "*.sh" -exec chmod +x {} \;
./first_run.sh
rm first_run.sh
rm install.sh
chmod +x /boot/firstboot.sh
EOF
