#!/bin/bash

function package_old {
  for package in $@
  do
     pacman -Ss $package | grep -E "${packages} .*installed: " &>/dev/null && echo $package
  done
}

function install_fresh {
  refresh_pkg_list="$(package_old $@)"
  if ! test -z $refresh_pkg_list
  then
     echo $refresh_pkg_list
     sudo pacman -Sy --noconfirm $refresh_pkg_list 2> /dev/null && echo && echo "==> All Archlinux keyring are updated!!" || false
  else
     echo "==> ArchLinux keyrings don't need to be update!!"
     echo
     exit 1
  fi
}

function forced-refresh {
	echo
	echo
	echo "[))> Using fallback -- [forced mode]--"

	sudo rm -rf /etc/pacman.d/gnupg
	sudo pacman-key --init
	sudo pacman-key --populat
	install_fresh $refresh_pkg_list --noconfirm
   echo
}

echo
echo "[))> Refresh Archlinux keyrings!!"
echo

sudo pacman -Sy
echo

install_fresh archlinux-keyring chaotic-keyring 2> /dev/null || forced-refresh

echo
