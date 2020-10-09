#!/bin/bash -e

on_chroot << EOF
cd /home/${FIRST_USER_NAME}
wget https://raw.githubusercontent.com/TamataOcean/OceanIsOpen/serial/systools/wifi_raspi/hostapd.conf -O /etc/hostapd/hostapd.conf
wget https://raw.githubusercontent.com/TamataOcean/OceanIsOpen/serial/systools/wifi_raspi/interfaces -O /etc/network/interfaces
wget https://raw.githubusercontent.com/TamataOcean/OceanIsOpen/serial/systools/wifi_raspi/dnsmasq.conf -O /etc/dnsmasq.conf
wget https://raw.githubusercontent.com/TamataOcean/OceanIsOpen/serial/systools/wifi_raspi/sysctl.conf -O /etc/sysctl.conf
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
wget https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/iptables.ipv4.nat -O /etc/iptables.ipv4.nat
wget https://raw.githubusercontent.com/TamataOcean/OceanIsOpen/serial/systools/wifi_raspi/rc.local -O /etc/rc.local
chmod +x  /etc/rc.local
systemctl unmask hostapd
systemctl enable hostapd
EOF
