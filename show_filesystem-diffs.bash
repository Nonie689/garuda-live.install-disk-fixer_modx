#!/bin/bash

echo "This tool shows you easiely the differenz when you changing a physical filesystem on the /dev/sdX list!!"
echo
echo "Press enter to save current physical filesystem list at /dev/sdX!!"
ls /dev/sd* > ~/.cache/phy_sdX.before.list
echo
read

echo "Please press enter again - When you change one or more filesystems on the /dev/sdX list!!"
echo
read

ls /dev/sd* > ~/.cache/phy_sdX.after.list

diff -u ~/.cache/phy_sdX.before.list ~/.cache/phy_sdX.after.list

rm ~/.cache/phy_sdX.before.list ~/.cache/phy_sdX.after.list
