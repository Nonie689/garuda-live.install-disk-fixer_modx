#!/bin/bash

not_important_pkgs="libreoffice-still-de libreoffice-still-fr libreoffice-still-da libreoffice-still-ru libreoffice-still-zh-cn libreoffice-still-nl libreoffice-still-sa-in libreoffice-still-es libreoffice-still-it"

total=45  # total wait time in seconds
count=0  # counter
first=true

function package_installed {
  for package in $@
  do
     pacman -Q $package 2> /dev/null | awk '{print $1}' 2> /dev/null
  done
}

function filter_just_new_packages {
  pkgs_list=$@

  for exclude in $(package_installed $@)
  do
     pkgs_list=$(echo $pkgs_list | sed -e "s/$exclude//g") 
  done

  if [[ -n $pkgs_list ]]
  then
     echo $pkgs_list
  else
     false
  fi
}

function install_pkgs {
   pkgs_query_tmp=$(filter_just_new_packages $@)
   filter_just_new_packages $@ &> /dev/null && sudo pacman -S --noconfirm $pkgs_query_tmp && bash -c "printf '\n\nFinished\n\n'"
}

function ask {
pkgs_query=$@
while [ ${count} -lt ${total} ]
do
pkgs_filtered=$(filter_just_new_packages $pkgs_query)
filter_just_new_packages $pkgs_query &> /dev/null || break

	while true
	do
		tlimit=$(( $total - $count ))
		if test $tlimit -eq 0 &> /dev/null ;
      then
         yn=y
         break
      fi
      if first
		then
      	echo -e "\n\n\n\n\n\n\n"
      fi
	   echo -e "\033[K\033[1A\033[K\033[1A\033[K\033[1A\033[K\033[1A\033[K\033[1A\033[K\033[1A\033[K\033[1A\033[K\033[1A[))> Installing not importantent packages...\n\nPackages to install: $pkgs_filtered \n\n Do you want to install this (yes/no)\n\n  ~> Proceed with yes in $tlimit seconds!!"
		read -t 1 yn
		test ! -z $yn && { break ; }
		count=$((count+1))
      first=false
	done

   case $yn in
        yes|y ) echo; echo Packages will be installed! ;
                install_pkgs $pkgs_filtered;
                break ;;
        no|n ) echo "Abort installation!";break ;;
        * ) echo invalid response;
            echo;;
   esac
done
}

ask $not_important_pkgs
