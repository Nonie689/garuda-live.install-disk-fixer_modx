#!/bin/bash

echo " $$__Tool to remount filesystems every second__$$"
echo
sudo mount | grep -E "/dev/sd|/dev/mapper"| awk '{print $1}'
echo

while true
do
   for devices in $(mount | grep -E "/dev/sd|/dev/mapper" | awk '{print $3}')
   do
     echo " *** Remounting $devices with rw mount option!!"
     sudo mount -o remount,rw $devices &>/dev/null && echo "[Done!]" || echo "[Fault!]"
   done
sleep 2
done &
