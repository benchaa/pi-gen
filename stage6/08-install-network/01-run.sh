#!/bin/bash -e

install -m 644 files/openplotter-network.service	"${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
echo "ExecStart=/home/${FIRST_USER_NAME}/.openplotter/start-ap-managed-wifi.sh" >> "/etc/systemd/system/openplotter-network.service"
echo "StandardOutput=syslog" >> "/etc/systemd/system/openplotter-network.service"
echo "StandardError=syslog" >> "/etc/systemd/system/openplotter-network.service"
echo "WorkingDirectory=/home/${FIRST_USER_NAME}/.openplotter" >> "/etc/systemd/system/openplotter-network.service"
echo "User=root" >> "/etc/systemd/system/openplotter-network.service"
echo "[Install]" >> "/etc/systemd/system/openplotter-network.service"
echo "WantedBy=multi-user.target" >> "/etc/systemd/system/openplotter-network.service"

echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' > '/etc/default/hostapd'

echo 'KERNEL=="usb0", SUBSYSTEMS=="net", RUN+="/bin/bash /home/${FIRST_USER_NAME}/.openplotter/Network/11-openplotter-usb0.sh"' > '/usr/lib/python3/dist-packages/openplotterNetwork/Network/udev/rules.d/11-openplotter-usb0.rules'

systemctl daemon-reload
systemctl unmask hostapd.service
systemctl enable openplotter-network
EOF