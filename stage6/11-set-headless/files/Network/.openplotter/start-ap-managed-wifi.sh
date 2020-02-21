#!/bin/sh
internet=auto
router=wlan9
sysctl -w net.ipv4.ip_forward=1
/bin/bash start1.sh
/bin/bash iptables.sh "$internet" "$router"
