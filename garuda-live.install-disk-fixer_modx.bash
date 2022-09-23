LC_ALL=C

## Just the init Area!

### To kill all simple run services
## kill $(ps -aux | grep -E "run-" | grep -v "grep" | awk '{print $2}') &> /dev/null

trap 'exit 130' INT

src_dir="$(dirname $(realpath $0))"
cachedir="$(realpath ~/.cache)"

sudo cp -rf $src_dir/config/proxychains.opera-proxy.conf /etc/ &> /dev/null

go_dispatch_cmd="go-dispatch-proxy -lport 4711 -tunnel  10.0.0.10:5090 10.0.0.10:5091 10.0.0.10:5092 10.0.0.10:5093 10.0.0.10:5094 10.0.0.10:5095 10.0.0.10:5096 10.0.0.10:5097 10.0.0.10:5098 10.0.0.10:5099 10.0.0.10:5100"
killall go-dispatch-proxy &>/dev/null

extra_packages="atom-editor-beta-bin k3b vlc gparted"

aur_packages="go-dispatch-proxy-git opera-proxy ix librewolf-extension-localcdn redsocks-git archtorify-git wayfire-plugins-extra"

#aur_packages="go-dispatch-proxy-git opera-proxy ix librewolf-extension-localcdn wf-ctrl-git wayfire-firedecor-git wayfire-plugins-extra-git redsocks-git archtorify-git"



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

function noask {
while true
do
   pkgs_query=$@
   pkgs_filtered=$(filter_just_new_packages $pkgs_query)
   filter_just_new_packages $pkgs_query &> /dev/null || break
   install_pkgs $pkgs_filtered && break
   exit
done
}

function package_dep {
  expac %N $@
}

function install_with_dep_update {
  install_fresh $(package_dep $@) ; sudo pacman -S $@ --noconfirm 2> /dev/null
}

function package_old {
  for packages in $@
  do
     pacman -Ss $packages | grep -E "installed: " | awk -F"[/| ]" '{print $2}' 2> /dev/null
  done
}

function aur_install {
  for aur_pkg in $@
  do
     pacman -Q $aur_pkg &> /dev/null && continue
     cd ~/.cache &> /dev/null
     git clone https://aur.archlinux.org/$aur_pkg.git 2> /dev/null || true
     cd $aur_pkg
     echo
     echo Building: $aur_pkg
     echo
     bash -c "makepkg -s --cleanbuild --noconfirm" &> /dev/null
     makepkg -i --noconfirm 2> /dev/null 3> /dev/null
     cd - &> /dev/null
     rm -rf $aur_install &> /dev/null
  done
}

function install_fresh {
  sudo pacman -S  --noconfirm $(package_old $@) 2> /dev/null
}

function uninstall_existing {
  pkgs_list="$(package_installed $@)"
  if [[ -n $pkgs_list ]]
  then
     sudo pacman -Rdd $pkgs_list --noconfirm 2> /dev/null
  fi
}

## Run Config overwriter!!

bash $src_dir/configs_overwrite.bash

## Go to workdir cache!!

cd ~/.cache &> /dev/null

## Init first update of repo when needet !!
test -e ./firevigeo-torloader/firevigeo.sh && sudo ./firevigeo-torloader/firevigeo.sh -k &> /dev/null


##############################################################################
#                                                                            #
#                                                                            #
                                                                             #
echo "-------------------------------------------------------------   "      #
echo "-------------------------------------------------------------   "      #
echo "----- 1. Fix the bad garuda stuff!! ----------------------      "      #
echo "----- 2. Freshup the arch keyring database!! --------------     "      #
echo "----- 3. Install Opera and Librewolf Browsers!! --------------  "      #
echo "----- 4. Install other needet packages!! --------------         "      #
echo "----- 5. Run go-dispatcher-proxy!! --------------               "      #
echo "----- 6. Start redsocks!! --------------------------            "      #
echo "----- 6. Install some extra packages!! --------------           "      #
echo "----- 7. Start firevigeo tor-proxy!! ----------------------     "      #
echo "----- 8. Show some infos about usefull commands!!-------------- "      #
echo "-------------------------------------------------------------   "      #
echo "-------------------------------------------------------------   "      #
                                                                             #
#                                                                            #
#                                                                            #
##############################################################################

sleep 1.5

## Install dependencies packages for tool to adjust garuda live disk correct!

pacman -Q pikaur &> /dev/null || sudo pacman -Sy


## Remove bad garuda stuff and refresh keyrings by reinstall them!

uninstall_existing snapper snapper-tools snap-pac firedragon kfiredragonhelper garuda-browser-settings garuda-common-settings garuda-system-maintenance garuda-migrations

install_fresh chaotic-keyring archlinux-keyring wayfire wlroots wf-config waybar wf-shell fmt spdlog poppler poppler-glib

## Install Extra packages

noask $extra_packages


######################################
########################################
#### END OF INITIAL STUFF !! #####
####################################
######################################

## Intall Area - The importent part of the tool!

noask librewolf opera xorg-xhost
killall wf-panel &> /dev/null && sleep 2 && nohup ~/run-wf-panel.sh &> /dev/null &

noask wayfire-plugins-extra ncdu vnstat gotop tor shellcheck pikaur-git pcmanfm-gtk3 opensnitch axel android-sdk-platform-tools irqbalance && echo

sudo systemctl enable --now vnstat 1> /dev/null
sudo systemctl enable --now opensnitchd 1> /dev/null
sudo systemctl enable --now irqbalance 1> /dev/null

noask proxychains conky alacritty

pidof librewolf &> /dev/null || nohup librewolf 'https://addons.mozilla.org/en-US/firefox/addon/videospeed/' 'https://addons.mozilla.org/en-US/firefox/addon/youtube-recommended-videos/' 'https://addons.mozilla.org/en-US/firefox/addon/mediareload/' 'https://addons.mozilla.org/en-US/firefox/addon/videos-hls-m3u8-mp4-downloader/' 'https://addons.mozilla.org/en-US/firefox/addon/print-edit-we/' 'https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/' 'https://addons.mozilla.org/en-US/firefox/addon/temporary-containers/' 'https://addons.mozilla.org/en-US/firefox/addon/export-cookies-txt/' 'https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/' 'https://addons.mozilla.org/en-US/firefox/addon/tranquility-1/' &> /dev/null &

sleep 25 && nohup librewolf 'https://github.com/Nonie689/garuda-live.install-disk-fixer_modx/'  'about:addons' &> /dev/null &

## Install Base requirements!

pacman -Q go-dispatch-proxy-git &> /dev/null || echo "Install: $aur_packages" && aur_install $aur_packages

killall waybar &> /dev/null
killall wf-background &> /dev/null
killall mako &> /dev/null
sleep 0.750

for nohup_exec in $(printf 'nohup %s &/dev/null & \n' ~/run-*)
do
   bash -c "$nohup_exec" &> /dev/null &
done


## Clone git repo we need!!

git clone https://github.com/Nonie689/firevigeo-torloader 2> /dev/null || true
git clone https://aur.archlinux.org/wf-info-git.git 2> /dev/null || true

cd wf-info-git
#sed -i "s/depends=.*/depends=(wayfire-git)/g" ./PKGBUILD
#pacman -Q wf-info-git &> /dev/null || makepkg -s --noconfirm &> /dev/null
#pacman -Q wf-info-git &> /dev/null || makepkg -i --noconfirm 2> /dev/null 3> /dev/null
cd - &> /dev/null

echo 
sudo systemctl enable --now redsocks 1> /dev/null

bash -c "sleep 5 && nohup librewolf 'https://check.torproject.org'" &> /dev/null &

pikaur -Scc --noconfirm &> /dev/null

## Start firevigeo!!

ls $(pwd)/firevigeo-torloader/ &> /dev/null && sudo $(pwd)/firevigeo-torloader/firevigeo.sh -s 2> /dev/null 

echo "[))> Run if you like,"
echo
echo "\\  $(pwd)/firevigeo-torloader/firevigeo.sh -s"

## End of the main stuff

gnome-terminal -t Install unimportant packages \(yes/no\) -- bash $src_dir/install_unimportant.bash &



