#!/bin/bash

function package_installed {
  for package in $@
  do
     pacman -Q $package 2> /dev/null | awk '{print $1}' 2> /dev/null
  done
}

function uninstall_existing {
  pkgs_list="$(package_installed $@)"
  if [[ -n $pkgs_list ]]
  then
     sudo pacman -Rdd $pkgs_list --noconfirm 2> /dev/null
  fi
}


uname -a | grep garuda &>/dev/null && uninstall_existing snapper snapper-tools snap-pac firedragon garuda-boot-options kfiredragonhelper garuda-browser-settings garuda-common-settings garuda-system-maintenance garuda-migrations archlinux-appstream-data-pamac libpamac-aur pamac-aur garuda-hooks garuda-hotfixes garuda-live-systemd garuda-starship-prompt garuda-welcome mhwd-db-garuda-git  mhwd-garuda-git
