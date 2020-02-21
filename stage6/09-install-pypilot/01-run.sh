#!/bin/bash -e

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.pypilot"
install -m 644 -o 1000 -g 1000 files/signalk.conf		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.pypilot/"
install -m 644 files/openplotter-pypilot-read.service	"${ROOTFS_DIR}/etc/systemd/system/"
install -m 644 files/pypilot.service	"${ROOTFS_DIR}/etc/systemd/system/"
install -m 644 files/pypilot_boatimu.service	"${ROOTFS_DIR}/etc/systemd/system/"
install -m 644 files/pypilot_lcd.service	"${ROOTFS_DIR}/etc/systemd/system/"
install -m 644 files/pypilot_webapp.service	"${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
echo "WorkingDirectory=/home/${FIRST_USER_NAME}/.pypilot" >> "/etc/systemd/system/pypilot_boatimu.service"
echo "User=${FIRST_USER_NAME}" >> "/etc/systemd/system/pypilot_boatimu.service"
echo "[Install]" >> "/etc/systemd/system/pypilot_boatimu.service"
echo "WantedBy=local-fs.target" >> "/etc/systemd/system/pypilot_boatimu.service"

echo "WorkingDirectory=/home/${FIRST_USER_NAME}/.pypilot" >> "/etc/systemd/system/pypilot.service"
echo "User=${FIRST_USER_NAME}" >> "/etc/systemd/system/pypilot.service"
echo "[Install]" >> "/etc/systemd/system/pypilot.service"
echo "WantedBy=local-fs.target" >> "/etc/systemd/system/pypilot.service"

echo "WorkingDirectory=/home/${FIRST_USER_NAME}/.pypilot" >> "/etc/systemd/system/pypilot_lcd.service"
echo "User=${FIRST_USER_NAME}" >> "/etc/systemd/system/pypilot_lcd.service"
echo "[Install]" >> "/etc/systemd/system/pypilot_lcd.service"
echo "WantedBy=local-fs.target" >> "/etc/systemd/system/pypilot_lcd.service"

echo "WorkingDirectory=/home/${FIRST_USER_NAME}/.pypilot" >> "/etc/systemd/system/pypilot_webapp.service"
echo "User=${FIRST_USER_NAME}" >> "/etc/systemd/system/pypilot_webapp.service"
echo "[Install]" >> "/etc/systemd/system/pypilot_webapp.service"
echo "WantedBy=local-fs.target" >> "/etc/systemd/system/pypilot_webapp.service"

echo "WorkingDirectory=/home/${FIRST_USER_NAME}/.pypilot" >> "/etc/systemd/system/openplotter-pypilot-read.service"
echo "User=${FIRST_USER_NAME}" >> "/etc/systemd/system/openplotter-pypilot-read.service"
echo "[Install]" >> "/etc/systemd/system/openplotter-pypilot-read.service"
echo "WantedBy=multi-user.target" >> "/etc/systemd/system/openplotter-pypilot-read.service"

systemctl daemon-reload

apt -y autoremove sense-hat
pip3 install pywavefront pyglet gps gevent-websocket python-socketio tensorflow

rm -f master.zip
rm -rf python-RTIMULib2-master
wget https://github.com/openplotter/python-RTIMULib2/archive/master.zip
unzip master.zip
rm -f master.zip
cd python-RTIMULib2-master
python3 setup.py build
python3 setup.py install
cd ..
rm -rf python-RTIMULib2-master

rm -f master.zip
rm -rf pypilot-master
rm -rf pypilot_data-master
wget https://github.com/openplotter/pypilot/archive/master.zip
unzip master.zip
rm -f master.zip
wget https://github.com/openplotter/pypilot_data/archive/master.zip
unzip master.zip
rm -f master.zip
cp -rv pypilot_data-master/. pypilot-master
cd pypilot-master
python3 setup.py build
python3 setup.py install
cd ..
rm -rf pypilot-master
rm -rf pypilot_data-master
EOF
