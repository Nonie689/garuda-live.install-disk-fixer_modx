#!/bin/bash

echo
echo Default garuda subvols with mountpoint!
echo
echo "/mntmysys/ -o subvol=@"
echo "/mntmysys/home -o  subvol=/@home"
echo "/mntmysys/root -o subvol=/@root"
echo "/mntmysys/srv -o subvol=/@srv"
echo "/mntmysys/var/cache -o subvol=/@cache"
echo "/mntmysys/var/log -o subvol=/@log"
echo "/mntmysys/var/tmp -o subvol=/@tmp"
echo
echo "Run with the correct LUKS name and choose the correkt subvol name for the subfolders!"
echo
echo "sudo mkdir /mnt-my_sys &> /dev/null; sudo mount /dev/mapper/ /mnt-my_sys/ -o subvol=@ "
echo
echo "Then use e.g. arch-chroot root folder /mntmysys/"
echo
