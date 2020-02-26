#!/bin/bash -e

on_chroot << EOF
sudo -u ${FIRST_USER_NAME} sudo moitessierPostInstall
EOF

install -m 644 files/10-openplotter.rules	"${ROOTFS_DIR}/etc/udev/rules.d/"
install -m 644 -o 1000 -g 1000 files/settings.json		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"
install -m 644 -o 1000 -g 1000 files/sk-to-nmea0183.json		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/plugin-config-data/"
install -m 644 -o 1000 -g 1000 files/opencpn.conf		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.opencpn/"

on_chroot << EOF
echo "[UDEV]" >> "/home/${FIRST_USER_NAME}/.openplotter/openplotter.conf"
echo "serialinst = {'ttyOP_hat': {'device': 'moitessier.tty', 'vendor': '', 'product': '', 'port': 'virtual', 'serial': '', 'remember': 'port', 'data': 'NMEA 0183'}}" >> "/home/${FIRST_USER_NAME}/.openplotter/openplotter.conf"
echo "[I2C]" >> "/home/${FIRST_USER_NAME}/.openplotter/openplotter.conf"
echo "sensors = {'MS5607-02BA03': {'address': '0x77', 'port': 51000, 'data': [{'SKkey': 'environment.outside.pressure', 'rate': 5.0, 'offset': 0.0}, {'SKkey': 'environment.inside.openplotter.temperature', 'rate': 5.0, 'offset': 0.0}]}}" >> "/home/${FIRST_USER_NAME}/.openplotter/openplotter.conf"

echo "i2c-dev" >> "/etc/modules"
sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g' /boot/config.txt
sed -i 's/#dtparam=spi=on/dtparam=spi=on/g' /boot/config.txt

systemctl enable pypilot_boatimu
systemctl enable openplotter-pypilot-read
systemctl enable openplotter-i2c-read

kernel=$(uname -r)
kernel0="$(cut -d'-' -f1 <<<"$kernel")"
wget -r -l1 -np -nd -A .deb -N https://get.rooco.tech/moitessier/buster/release/$kernel0/latest/ || true
dpkg -i moitessier_$kernel0_*_armhf.deb || true
rm -f moitessier_$kernel0_*_armhf.deb || true
EOF
