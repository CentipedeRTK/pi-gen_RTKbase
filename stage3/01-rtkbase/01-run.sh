#!/bin/bash -e

install -m 644 files/first_run.sh ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/
install -m 644 files/unsed.sh ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/

on_chroot << EOF
cd /home/${FIRST_USER_NAME}
ls
find ./ -type f -iname "*.sh" -exec chmod +x {} \;
./first_run.sh
rm first_run.sh
EOF
