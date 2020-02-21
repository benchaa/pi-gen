#!/bin/bash -e

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openplotter/moitessier"
install -m 644 -o 1000 -g 1000 files/moitessier_4.19.75_1.4.0_armhf.deb		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openplotter/moitessier/"

install -m 644 files/10-openplotter.rules	"${ROOTFS_DIR}/etc/udev/rules.d/"
install -m 644 -o 1000 -g 1000 files/settings.json		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"
install -m 644 -o 1000 -g 1000 files/sk-to-nmea0183.json		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/plugin-config-data/"
install -m 644 -o 1000 -g 1000 files/openplotter.conf		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.openplotter/"
install -m 644 -o 1000 -g 1000 files/opencpn.conf		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.opencpn/"

on_chroot << EOF
echo "i2c-dev" >> "/etc/modules"
sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g' /boot/config.txt

sed -i 's/#dtparam=spi=on/dtparam=spi=on/g' /boot/config.txt

echo "dtoverlay=i2c-gpio,i2c_gpio_sda=2,i2c_gpio_scl=3,bus=3" >> "/boot/config.txt"
dpkg -i /home/${FIRST_USER_NAME}/.openplotter/moitessier/moitessier_4.19.75_1.4.0_armhf.deb

systemctl enable pypilot_boatimu
systemctl enable openplotter-pypilot-read
systemctl enable openplotter-i2c-read
EOF
