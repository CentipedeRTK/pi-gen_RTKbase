#!/bin/bash -e

install -m 644 files/oio_bd_init.sh ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/

on_chroot << EOF
echo "host    all             all             0.0.0.0/0              md5" >> /etc/postgresql/11/main/pg_hba.conf
echo "listen_addresses = '*' " >> /etc/postgresql/11/main/postgresql.conf
EOF

on_chroot << EOF
cd /home/${FIRST_USER_NAME}
wget https://raw.githubusercontent.com/TamataOcean/OceanIsOpen/serial/sql/oio.sql -O ./oio.sql
EOF
