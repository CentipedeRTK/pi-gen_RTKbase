#!/bin/bash -e

on_chroot << EOF
wget https://nodejs.org/dist/v10.22.1/node-v10.22.1-linux-armv7l.tar.gz
tar -C /usr/local --strip-components 1 -xzf node-v10.22.1-linux-armv7l.tar.gz
EOF
