#!/bin/bash -e

#https://pypi.org/project/PyAccessPoint/

on_chroot << EOF
pip3 install wireless netifaces psutil packaging pyaccesspoint 

EOF
