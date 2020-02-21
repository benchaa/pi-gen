#!/bin/bash -e

install -m 644 files/openplotter-i2c-read.service	"${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
echo "User=${FIRST_USER_NAME}" >> "/etc/systemd/system/openplotter-i2c-read.service"
echo "[Install]" >> "/etc/systemd/system/openplotter-i2c-read.service"
echo "WantedBy=multi-user.target" >> "/etc/systemd/system/openplotter-i2c-read.service"

systemctl daemon-reload
EOF
