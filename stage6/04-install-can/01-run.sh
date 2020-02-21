#!/bin/bash -e

install -m 644 files/openplotter-can-read.service	"${ROOTFS_DIR}/etc/systemd/system/"
on_chroot << EOF
echo "ExecStart=openplotter-can-read" >> "/etc/systemd/system/openplotter-can-read.service"
echo "StandardOutput=syslog" >> "/etc/systemd/system/openplotter-can-read.service"
echo "StandardError=syslog" >> "/etc/systemd/system/openplotter-can-read.service"
echo "WorkingDirectory=/home/${FIRST_USER_NAME}" >> "/etc/systemd/system/openplotter-can-read.service"
echo "User=root" >> "/etc/systemd/system/openplotter-can-read.service"
echo "[Install]" >> "/etc/systemd/system/openplotter-can-read.service"
echo "WantedBy=multi-user.target" >> "/etc/systemd/system/openplotter-can-read.service"
EOF

on_chroot << EOF
systemctl daemon-reload
systemctl enable openplotter-can-read.service
EOF