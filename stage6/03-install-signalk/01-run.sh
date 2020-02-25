#!/bin/bash -e

on_chroot << EOF
sudo -u ${FIRST_USER_NAME} sudo signalkPostInstall
EOF

#install sk
##on_chroot << EOF
##npm install --verbose -g --unsafe-perm signalk-server
##EOF

#config sk
##install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/plugin-config-data"
##install -m 644 -o 1000 -g 1000 files/package.json		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"
##install -m 644 -o 1000 -g 1000 files/settings.json		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"
install -m 644 -o 1000 -g 1000 files/set-system-time.json		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/plugin-config-data/"
##install -m 775 -o 1000 -g 1000 files/signalk-server		"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.signalk/"
##on_chroot << EOF
##echo "/usr/lib/node_modules/signalk-server/bin/signalk-server -c /home/${FIRST_USER_NAME}/.signalk $*" >> "/home/${FIRST_USER_NAME}/.signalk/signalk-server"
##EOF

#autorun sk
##install -m 644 files/signalk.socket		"${ROOTFS_DIR}/etc/systemd/system/"
##install -m 644 files/signalk.service		"${ROOTFS_DIR}/etc/systemd/system/"
##on_chroot << EOF
##echo "ExecStart=/home/${FIRST_USER_NAME}/.signalk/signalk-server" >> "/etc/systemd/system/signalk.service"
##echo "Restart=always" >> "/etc/systemd/system/signalk.service"
##echo "StandardOutput=syslog" >> "/etc/systemd/system/signalk.service"
##echo "StandardError=syslog" >> "/etc/systemd/system/signalk.service"
##echo "WorkingDirectory=/home/${FIRST_USER_NAME}/.signalk" >> "/etc/systemd/system/signalk.service"
##echo "User=${FIRST_USER_NAME}" >> "/etc/systemd/system/signalk.service"
##echo "Environment=EXTERNALPORT=3000" >> "/etc/systemd/system/signalk.service"
##echo "[Install]" >> "/etc/systemd/system/signalk.service"
##echo "WantedBy=multi-user.target" >> "/etc/systemd/system/signalk.service"
##EOF

##on_chroot << EOF
##systemctl daemon-reload
##systemctl enable signalk.service
##systemctl enable signalk.socket
##EOF

#install sk plugins
on_chroot << EOF
cd /home/${FIRST_USER_NAME}/.signalk
npm i --verbose signalk-to-nmea2000
npm i --verbose signalk-n2kais-to-nmea0183
chown -R ${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/.signalk
EOF