
## Just the init Area!

####################################################################################################
#################################  To kill all simple run services #################################
####### kill $(ps -aux | grep -E "run-" | grep -v "grep" | awk '{print $2}') &> /dev/null    #######
####################################################################################################
# Set trap that we could quit correct with ctrl+c !!
trap 'exit 130' INT

# Set lange for programm outputs to US/UK-English to have an unified stout/sterr experience !!
LC_ALL=C
opensnitch=true
################################################

##########################
## Set init variables!! ##
##########################
###
# Some usefull variables

src_dir="$(dirname $(realpath $0))"
cachedir="$(realpath ~/.cache)"

go_dispatch_cmd="go-dispatch-proxy -lport 4711 -tunnel  10.0.0.10:5090 10.0.0.10:5091 10.0.0.10:5092 10.0.0.10:5093 10.0.0.10:5094 10.0.0.10:5095 10.0.0.10:5096 10.0.0.10:5097 10.0.0.10:5098 10.0.0.10:5099 10.0.0.10:5100"

### All archlinux packages that will grouped be touched or used!!

extra_packages="k3b vlc gparted wayfire-plugins-extra ncdu vnstat gotop tor shellcheck pikaur-git pcmanfm-gtk3 opensnitch axel android-sdk-platform-tools irqbalance ripgrep"

aur_packages="apm electron5-bin go-dispatch-proxy-git opera-proxy ix atom-transparent librewolf-extension-localcdn redsocks-git archtorify-git"

need_package_install_from_repo="librewolf opera xorg-xhost shellcheck"

depends_pkg="proxychains-ng conky alacritty"

update_pkgs_early_stage="chaotic-keyring archlinux-keyring wayfire wlroots wf-config waybar wf-shell fmt spdlog poppler poppler-glib"


################################################

#########################
## Declare functions!! ##
#########################

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
   filter_just_new_packages $@ &> /dev/null && sudo pacman -S --noconfirm $pkgs_query_tmp
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
     cd ~/.cache
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

function uninstall_existing {
  pkgs_list="$(package_installed $@)"
  if [[ -n $pkgs_list ]]
  then
     sudo pacman -Rdd $pkgs_list --noconfirm 2> /dev/null
  fi
}

function install_fresh {
  sudo pacman -S  --noconfirm $(package_old $@) 2> /dev/null
}


#################################################
######### END OF INITIALIZE-STUFF AREA #########
###################################################

## Run Systeem config custimizing tool and set a good and logical core configuration !!
bash $src_dir/configs_overwrite.bash


## Go to workdir cache!!
cd ~/.cache &> /dev/null


## Init first update of repo when needet !!
ls /firevigeo-torloader &>/null || git clone https://github.com/Nonie689/firevigeo-torloader
test -e ./firevigeo-torloader/firevigeo.sh && sudo ./firevigeo-torloader/firevigeo.sh -k &> /dev/null


#####################################################################################   ^ ^
##                                                                                   *       *
### ~>> Show the work steps that are we will want all to do !!!                   <<    (-)    >>
##                                                                                   *       *
##                                                                           ########   >V<
##############################################################################
#                                                                            #
#                                                                            #
                                                                             #
echo "-------------------------------------------------------------   "      #
echo "-------------------------------------------------------------   "      #
echo "-----  1. ~> Install must have depences package!!  -----------  "      #
echo "-----  2. ~> Fix the bad garuda stuff!! --------------------    "      #
echo "-----  3. ~> Freshup the arch keyring database!! ------------   "      #
echo "-----  4. ~> Install Area: Install Browsers!! ------------      "      #
echo "-----  5. ~> Install other needet packages!! ------------       "      #
echo "-----  6. ~> Stop and start some systemd services!! -------     "      #
echo "-----  7. ~> Show good librewolf AddOns!! ---------------       "      #
echo "-----  8. ~> Install a long list of extra packages !! ------    "      #
echo "-----  9. ~> Clean local stored packages from cache !! ----     "      #
echo "----- 10. ~> Start firevigeo tor-proxy!! ---------------------- "      #
echo "----- 11. ~> Show some infos about usefull commands!! --------  "      #
echo "----- 12. ~> Tweak and hardening sudo configs !! ----------     "      #
echo "-------------------------------------------------------------   "      #
echo "-----------------------------------------------------------     "      #
                                                                             #
#                                                                            #
#                                                                            #
##############################################################################
                                                                              #################
sleep 2.75                                                                               ###############
                                                                                     #########################
############################################################################################

## Install dependencies packages for tool to adjust garuda live disk correct!!

echo && pacman -Q pikaur &> /dev/null || sudo pacman -Sy 2> /dev/null

#############################################################################
## Remove bad garuda stuff and refresh keyrings by reinstall them!!         ####
# Just some not usefull and bad preinstalled packages!!                      ###############################################################
#                                                                                                                                    #############
### Maybe some crawler tools, deep unclear modding packages, bad garuda brand tools and stuff, maybe risky browser settings also!!            ################
#                                                                                                                                                   ###############
### Soooo it will delete!!                                                                                                                                     #############
##                                                                                                                                                                        ###########
uninstall_existing snapper snapper-tools snap-pac firedragon kfiredragonhelper garuda-browser-settings garuda-common-settings garuda-system-maintenance garuda-migrations      ############


#################################################################################################################################################################################
####                                                              #####
## Refresh archlinux and chaotic keyring when they are outdated!!   ####
# See ~> update_pkgs_early_stage                                   ####
##
install_fresh $update_pkgs_early_stage || bash refresh-keyrings.bash


####################################
######################################
##
####                           ####
########   [ MAIN-AREA ]   ########
####                           ####
##
####################################
#####


   ######################################
 #### Package install Area !!! ######
################################


## First install programm which are needet at early stage!!
# See ~> need_package_install_from_repo
##
noask $need_package_install_from_repo


## Second install all other usefull packages!!
# See ~> extra_packages
##
noask $extra_packages

pacman -Q pacaur &> /dev/null || pikaur -S pacaur --noconfirm --noedit  &> /dev/null && echo "Build and install pacaur!" || bash -c "echo Building of pacaur failed!! Please try manuel!! && exit 1"
sudo cp -rf $src_dir/config/pacaur/ /etc/xdg/

## Install dependens for use garuda as livecd!!
# See ~> depends_pkg
##
noask $depends_pkg


##  Show librewolf usefull librewolf AddOns!!
#
pidof librewolf &> /dev/null || nohup librewolf 'https://addons.mozilla.org/en-US/firefox/addon/videospeed/' 'https://addons.mozilla.org/en-US/firefox/addon/youtube-recommended-videos/' 'https://addons.mozilla.org/en-US/firefox/addon/mediareload/' 'https://addons.mozilla.org/en-US/firefox/addon/videos-hls-m3u8-mp4-downloader/' 'https://addons.mozilla.org/en-US/firefox/addon/print-edit-we/' 'https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/' 'https://addons.mozilla.org/en-US/firefox/addon/temporary-containers/' 'https://addons.mozilla.org/en-US/firefox/addon/export-cookies-txt/' 'https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/' 'https://addons.mozilla.org/en-US/firefox/addon/tranquility-1/' &> /dev/null &
sleep 25 && nohup librewolf 'https://github.com/Nonie689/garuda-live.install-disk-fixer_modx/'  'about:addons' &> /dev/null &


## Install all Aur stored packages and requirements!
# See list ~> aur_packages
##
pacman -Q go-dispatch-proxy-git &> /dev/null || echo "Install: $aur_packages" && aur_install $aur_packages

## Install Extra packages
# Wait that pacaur is finished!!
while true
do
  if ! test $(pgrep pacaur &>/dev/null)
  then
    break
  fi
  sleep 0.75
done

sleep 2 && noask $extra_packages


## Stop and start systemd services!!

sudo systemctl stop avahi-daemon.socket &> /dev/null
sudo systemctl stop avahi-daemon.service &> /dev/null
sudo systemctl stop avahi-daemon.socket &> /dev/null
sudo systemctl stop mhwd-live.service &> /dev/null

sudo systemctl start vnstat 1> /dev/null
sudo systemctl start irqbalance 1> /dev/null

if $opensnitch
then
  sudo systemctl start opensnitchd 1> /dev/null
fi
## Desktop gadget and workflow control will be established !!!

killall waybar &> /dev/null
killall wf-background &> /dev/null
killall mako &> /dev/null
killall wf-panel &> /dev/null

sleep 0.250

kill $(ps -ef | grep -E "bash $HOME/run-.*.sh" | grep -v grep | head --lines=-1 | awk '{ print $2}') &> /dev/null
for runscripts in ~/run-*
do
  echo "Starting: $runscripts"
  bash -c "$runscripts" &>/dev/null &
done

sleep 0.750
disown $(jobs -l | grep -E "run-*.sh" | awk '{ print $2'})  && echo

sudo systemctl start redsocks 1> /dev/null

sudo bash $src_dir/install_unimportant.bash


## Clean repo package cache to safe ram!

pikaur -Scc --noconfirm &> /dev/null


##################
#### Just go into the global ghostchip mode via tor that are loadbalanced!!
#######
#######################
## Start firevigeo!! ##
#######################

~/firevigeo -s


## Show torprojec test site!!

bash -c "sleep 5 && nohup librewolf 'https://check.torproject.org'" &> /dev/null &


## At least show just some infos for usage at the!!

echo "[))> Run if you like to restart firevigeo:"
echo
echo "~/firevigeo -s"


## Tweak sudo settings to hardening the base system!!

sudo bash $src_dir/sudo-hardening-pro_tweaks.bash

#### !!!! END LINE ~>> HOPE ALL DONE WITHOUT FAILURES AND HOW DO YOU LIKE IT <<~ !!!! ####


