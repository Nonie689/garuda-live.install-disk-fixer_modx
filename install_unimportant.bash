not_important_pkgs="libreoffice-fresh-de libreoffice-fresh-fr libreoffice-fresh-da libreoffice-fresh-de libreoffice-fresh-ru libreoffice-fresh-zh-cn libreoffice-fresh-nl libreoffice-fresh-bg libreoffice-fresh-sa-in libreoffice-fresh-es libreoffice-fresh-it"

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
while true
do
pkgs_filtered=$(filter_just_new_packages $pkgs_query)
filter_just_new_packages $pkgs_query &> /dev/null || break
printf "[))> Do you want to install not important packages: (yes/no)?\n\nPackages: $pkgs_filtered\n\n Install: (yes/no)? "
read yn
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
