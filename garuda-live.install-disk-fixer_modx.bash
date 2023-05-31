#!/bin/bash

## Just the init Area!

####################################################################################################
#################################  To kill all simple run services #################################
####### kill $(ps -aux | grep -E "run-" | grep -v "grep" | awk '{print $2}') &> /dev/null    #######
####################################################################################################
# Set trap that we could quit correct with ctrl+c !!
trap 'exit 130' INT

# Set lange for programm outputs to US/UK-English to have an unified stout/sterr experience !!
version=0.97beta
LC_ALL=C
opensnitch=true
################################################

### expac "%n %m" -l'\n' -Q $(pacman -Qq) | sort -rhk 2 | head -40 | less   ## Shows the 40 biggest packages!

##########################
## Set init variables!! ##
##########################
###
# Some usefull variables

src_dir="$(dirname $(realpath $0))"
cachedir="$(realpath ~/.cache)"

####################################################################
### All archlinux packages that will grouped be touched or used!! #####
#########################################################################
##### List of unwanted packages to remove! ########################

## Not to remove anymore?? 
# lib32-libelf libelf
uninstall_conflicts="poppler wl-clipboard ffmpeg kanshi"

uninstall_oversized_pkgs="noto-fonts ttf-iosevka-nerd garuda-wallpapers libstaroffice ttf-fira-sans mesa-demos lib32-mesa-demos fwupd gnome-firmware"

uninstall_late="noto-fonts-cjk js102 breezy"

###################################################################################
## List of pacman repo packages that will be updated and installed when needed! ##
#################################################################################

update_pkgs_early_stage="wayfire wcm wf-config waybar wf-shell fmt spdlog wireplumber libwireplumberjson-glib glib2 python"

depends_pkg="proxychains-ng conky alacritty gpm python-stem systemd systemd-libs"

need_package_install_from_repo="fnott librewolf opera htmlq xorg-xhost shellcheck openssl openssl-1.1 libdrm wayland-utils wayland-protocols exa starship libgit2"

extra_packages="scdoc yakuake gthumb lshw hardinfo dmidecode hwdata mate-utils yelp hwdetect hwinfo usbview systemd-ui systemdgenie cmake kvantum qca-qt5 python-pyqt5-sip appstream-qt ffnvcodec-headers xorg-xauth vlc yt-dlp poppler poppler-glib repose pkgfile k3b gparted ncdu vnstat gotop tor shellcheck pikaur bat devtools opensnitch  axel android-sdk-platform-tools irqbalance ripgrep klavaro xorg-xlsclients qt5-wayland vdpauinfo libvdpau-va-gl qt5-tools python-grpcio-tools libglvnd libinput opengl-driver xcb-util-errors xcb-util-renderutil xcb-util-wm xorg-xwayland glslang meson ninja vulkan-headers tracker3 json-glib libsoup3 libstemmer libxml2 sqlite libsoup pixman xf86-input-libinput seatd spirv-tools vulkan-icd-loader vulkan-tools lib32-vulkan-icd-loader egl-wayland eglexternalplatform mesa-utils libxfixes libxrender  default-cursors libxcursor vulkan-mesa-layers"

## List of aur packages that will be installed!
#
####
# wlroots-no-axrgb-assert-git  maybe??
####
#
# icu71-bin gnethogs
pikaur_pkgs="fnott yambar-wayland nsntrace netinfo-ffi nethogs darkstat netproc-git ntopng-bin go-dispatch-proxy-git redsocks wl-clipboard-rs wshowkeys-git libelf wf-recorder"

#TODO fnott notifier implemention -> https://codeberg.org/dnkl/fnott


## TODO !!!!!!!  https://code.ungleich.ch/ungleich-public/cdist/
# 
## https://www.nico.schottelius.org/software/cuni/
##
##
## https://www.nico.schottelius.org/software/cinit/
############ https://code.ungleich.ch/ungleich-public/ccollect
##
#

############################# TOOOOOOOOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDOOOOOOOOOOOOOOO
###################
#
##https://slist.lilotux.net/linux/nethogs-qt/index_en.html
# pip2 install hogwatch --upgrade
#############
#######################################################
##################################################

aur_packages_1="kanshi-git rg wcm-git udev-notify-git usbguard-notifier-git usbguard-git hidviz hid_listen usbautomator ebtables sakura libva-vdpau-driver-wayland" # libva-vdpau-driver-wayland -- set vlc to use xvideo output on native xwayland mode!

# wvkbd
aur_packages_2="opera-proxy ix archtorify-git wshowkeys-git rofi-lbonn-wayland-only-git"

## TODO https://github.com/mozilla-services/syncstorage-rs firefox-syncstorage

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

function save_latest_mozilla_addon {
  # Get xpi addon url and save them!
  for xpi_url in $(curl $@ --silent | htmlq --attribute href a | grep xpi)
  do
     wget -q $xpi_url
  done
}

function noask {
  sudo pacman -S $@ --noconfirm
}

function package_dep {
  expac %N $@
}

function install_with_dep_update {
  install_fresh $(package_dep $@) ; sudo pacman -S $@ --noconfirm 2> /dev/null
}

function package_old {
  for package in $@
  do
     pacman -Ss $package | grep -E "${packages} .*installed: " &>/dev/null && echo $package
  done
}


function aur_install {
  echo "==> Building and install: $@"
  echo
  sleep 0.25

  # Install packages and store packages that are complete to persistent storage
  pacman -Q hostapd &> /dev/null && sudo pacman -Rdd hostapd --noconfirm

  # Create local aur repo cache directory
  mkdir $src_dir/pacman-cache/aur &> /dev/null

  # Delete packages older then n days!
  find $src_dir/pacman-cache/aur/ -name *.zst -type f -mtime +14 | xargs rm -f

  # Get pkgs to install with reading the parameter value
  pikaur -S $@ --noedit --noconfirm

  # Backup all new created aur packages to local aur cache folder!
  cp -r ~/.cache/pikaur/pkg/* $src_dir/pacman-cache/aur/

  ## Done!!

#  for aur_pkg in $@
#  do
#     if test -d $src_dir/pacman-cache/aur/cache/$aur_pkg
#     then
#        continue
#     fi
#     pacman -Q $aur_pkg &> /dev/null && continue
#     bash -c "cd $src_dir/pacman-cache/aur/cache && echo ==> Cloning: $aur_pkg && git clone https://aur.archlinux.org/${aur_pkg}.git 2> /dev/null && cd ${src_dir}/pacman-cache/aur/cache/${aur_pkg} && echo ==> Building: $aur_pkg && bash -c makepkg --cleanbuild --noconfirm" &> /dev/null &
#  done
#
#  sleep 3
#
#  while true
#  do
#    if test "$(jobs | grep -v -E 'makepkg --cleanbuild')"
#    then
#      break
#    fi
#    sleep 1
#  done
#
#  for aur_pkg in $@
#  do
#     pacman -Q $aur_pkg &> /dev/null && continue
#     cd ${src_dir}/pacman-cache/aur/cache/$aur_pkg && echo && echo "==> Install: $aur_pkg" && makepkg -i --noconfirm 2> /dev/null 3> /dev/null
#  done
#
  echo
  echo "[))> Finish all AUR package building!!"
  echo
}

function uninstall_existing {
  pkgs_list="$(package_installed $@)"
  if [[ -n $pkgs_list ]]
  then
     sudo pacman -Rdd $pkgs_list --noconfirm 2> /dev/null
  fi
}

function install_fresh {
  refresh_pkg_list="$(package_old $@)"
  if ! test -z "$refresh_pkg_list"
  then
     sudo pacman -S --noconfirm $refresh_pkg_list 2> /dev/null && echo
  fi
}



#########################################################################

#################################################
######### END OF INITIALIZE-STUFF AREA #########
###################################################

#########################################################################

echo
echo "[))> garuda-LiveCD ModX fixer tool!!  -- version ${version}"

sleep 1.6

#test -e pacman-cache.qcow2 || qemu-img create -f qcow2 ${src_dir}/pacman-cache.qcow2 40G || qemu-img create -f qed pacman-cache.qed 40G

#virsh attach-disk pacman-cache --source ${src_dir}/vdisk1 --target vdc --driver qemu

cd $src_dir

# Insert logx entry
echo " --- Garuda CD startet on: $(uptime | awk '{print $1'}) --- LiveMODX Tool started at: $(date '+//=>> on %A ::: %Y.%m.%d - %H:%M :::')" >> $src_dir/log/pacman.log
echo " --- Garuda CD startet on: $(uptime | awk '{print $1'}) --- LiveMODX Tool started at: $(date '+//=>> on %A ::: %Y.%m.%d - %H:%M :::')" >> $src_dir/log/garuda-live-cd_modx.log

## Run Systeem config custimizing tool and set a good and logical core configuration !!

bash $src_dir/configs_overwrite.bash

## Go to workdir cache!!

cd ~/.cache &> /dev/null

####################################################
## Init first update of repo when needet !!  #####
#################################################

ls firevigeo-torloader &>/dev/null || git clone https://github.com/Nonie689/firevigeo-torloader 2> /dev/null || true
ls firevigeo-torloader &> /dev/null && sudo ./firevigeo-torloader/firevigeo.sh -k &> /dev/null



#####################################################################################   ^ ^
##                                                                                   *       *
### ~>> Show the work steps that are we will want all to do !!!                   <<    (-)    >>
##                                                                                   *       *
##                                                                           ########   >V<
##############################################################################
#                                                                            #
#                                                                            #
                                                                             #
echo                                                                         #
echo "Tool will do these steps!!"                                            #
echo                                                                         #
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
sudo pacman -Sy                                                                                ##################################
sudo pacman -Q wl-clipboard-rs &> /dev/null || uninstall_existing $uninstall_conflicts $uninstall_oversized_pkgs  #######################
                                                                                                                       #################
############################################################################################################################

sudo mkdir -p  /usr/share/wallpapers/garuda-wallpapers/ &> /dev/null && sudo cp $src_dir/Ghosts.jpg /usr/share/wallpapers/garuda-wallpapers/Ghosts.jpg

## Install dependencies packages for tool to adjust garuda live disk correct!!

#############################################################################
## Remove bad garuda stuff and refresh keyrings by reinstall them!!         ####
# Just some not usefull and bad preinstalled packages!!                      ###############################################################
#                                                                                                                                    #############
### Maybe some crawler tools, deep unclear modding packages, bad garuda brand tools and stuff, maybe risky browser settings also!!            ################
#                                                                                                                                                   ###############
### Soooo it will delete!!
#############
##                                                                                                                                                                        ###########
                                                                                                                                                                            ###########
bash $src_dir/remove-unwanted-garuda-stuff.bash

###############

##########################

#######################
#######################################################################################################################################################################################
###################################################################################################################################################################
###################################################################################################################################################
############################################################################################
####                                                                   ############
## Refresh archlinux and chaotic keyring when they are outdated!!      #########
# See ~> update_pkgs_early_stage                                       ########
##########################################################################
######################################################################

bash $src_dir/refresh-keyrings.bash
install_fresh $update_pkgs_early_stage

wf-shell &> /dev/null &


#######################################
######################################
#######################################
######################################
##
####                           ####
########   [ MAIN-AREA ]   ########
####                           ####
##
#######################################
######################################
#######################################
######################################
####################################
#####


   ######################################
   #### Package install Area !!! #####
    #################################


########
######
#######

#####
    ## First install programm which are needet at early stage!!
    # See ~> need_package_install_from_repo
    ##
#####

pacman -Q librewolf &> /dev/null || noask $need_package_install_from_repo

## Second install all other usefull packages!!
# See ~> extra_packages
##

pacman -Q android-sdk-platform-tools &> /dev/null || noask ${extra_packages}

## Install dependens for use garuda as livecd!!
# See ~> depends_pkg
##

pacman -Q proxychains-ng &> /dev/null || noask ${depends_pkg}


## Update icu with all packages that need to updatate cause new icu runtime api version!
#

sudo pacman -S --noconfirm bind  boost-libs  garuda-settings-manager  gnustep-base  gspell  harfbuzz-icu  lib32-icu  lib32-libxml2  libcdr  libical  libmspub  libvisio  libxml2  raptor  smbclient  tracker3  unarchiver  webkit2gtk  webkit2gtk


##  Download very good Firefox AddOns for Librewolf Browser!!
#
####
#




## Save latest mozilla addon to Librewolf-extensions/bin
  rm -rf $src_dir/Librewolf-extensions/bin ; mkdir  $src_dir/Librewolf-extensions/bin
  cd $src_dir/Librewolf-extensions/bin

save_latest_mozilla_addon 'https://addons.mozilla.org/en-US/firefox/addon/videospeed/ https://addons.mozilla.org/en-US/firefox/addon/mediareload/ https://addons.mozilla.org/en-US/firefox/addon/export-cookies-txt/ https://addons.mozilla.org/en-US/firefox/addon/bulk-media-downloader/ https://addons.mozilla.org/en-US/firefox/addon/unload-tabs/ https://addons.mozilla.org/en-US/firefox/addon/video-downloader-profession/ https://addons.mozilla.org/en-US/firefox/addon/flagfox/ https://addons.mozilla.org/en-US/firefox/addon/storagerazor/ https://addons.mozilla.org/en-US/firefox/addon/cookies-and-headers-analyser/ https://addons.mozilla.org/en-US/firefox/addon/ninja-cookie/ https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/ https://addons.mozilla.org/en-US/firefox/addon/forget_me_not/ https://addons.mozilla.org/en-US/firefox/addon/cookieblock/ https://addons.mozilla.org/en-US/firefox/addon/minimal-consent/ https://addons.mozilla.org/en-US/firefox/addon/onlyfans/ https://addons.mozilla.org/en-US/firefox/addon/over-18-cookie/' 'https://addons.mozilla.org/en-US/firefox/addon/the-m3u8-stream-detector/'

cd -

## Downloading finished!!


## Start librewolf with various of usefull sites!
pidof librewolf &> /dev/null || nohup librewolf $src_dir/Librewolf-extensions/bin/ 'about:addons' &> /dev/null &

sudo pacman -S $(expac -Q %D vlc) $(expac -Q %o vlc) gst-libav gst-plugin-gtk gst-python gst-plugins-ugly gst-plugins-good  gst-plugins-base gst-plugins-bad gst-plugins-bad-libs mpv libsndfile libopenmpt lib32-ncurses lib32-alsa-lib gstreamer-vaapi pipewire --noconfirm

sudo cp /usr/lib/libunistring.so.2  /usr/lib/libunistring.so.5 &> /dev/null


## Install all Aur stored packages and requirements!
# See list ~> aur_packages_1  aur_packages_2
##
echo; echo; sleep 1

pacman -Q  libva-vdpau-driver &> /dev/null && sudo pacman -Rdd libva-vdpau-driver --noconfirm

aur_install $pikaur_pkgs
aur_install $aur_packages_1
aur_install $aur_packages_2


#############################
## Install wlroots-nvidia ###
#############################

pacman -Q wlroots &> /dev/null && pikaur -Rdd wlroots --noconfirm

cd ~/.cache
pikaur -G wlroots-nvidia

cd wlroots-nvidia
## Restore buildet wlroots package to reuse it!!
pacman -U $srcdir/pikaur-cache/pkg/wlroots-nvidia*zst ./ &> /dev/null || ( makepkg -si --skippgpcheck --noconfirm && cp ~/.cache/wlroots-nvidia/wlroots-nvidia*zst $srcdir/pikaur-cache/pkg/ )


########################
## Install wlr-randr ###
########################

cd ~/.cache
pikaur -G wlr-randr

cd wlr-randr
## Restore buildet wlr-randr package to reuse it!!
pacman -U $srcdir/pikaur-cache/pkg/wlr-randr*zst ./ &> /dev/null || ( makepkg -si --skippgpcheck --noconfirm && cp ~/.cache/wlr-randr/wlr-randr*zst $srcdir/pikaur-cache/pkg/ )


########################################
## Remove possible packages latefull ##
#######################################

pacman -Q breezy &> /dev/null || uninstall_existing $uninstall_conflicts $uninstall_late


############################################
### Setup my own display randr options!! ###
#############################################

sleep 0.5 && bash ~/wlr-randr-multihead-my_own_config.bash


#####################################
## Setup and loadi kernel modules ##
###################################

sudo modprobe zram
echo lz4 > sudo /sys/block/zram0/comp_algorithm
sudo modprobe drm


##############################
### Stop systemd services!! #
############################

sudo systemctl stop avahi-daemon.socket &> /dev/null
sudo systemctl stop avahi-daemon.service &> /dev/null
sudo systemctl stop avahi-daemon.socket &> /dev/null
sudo systemctl stop mhwd-live.service &> /dev/null
sudo systemctl stop systemd-oomd.service &> /dev/null


#############################
## Start systemd services ##
###########################

sudo systemctl start modprobe@drm.service &> /dev/null
sudo systemctl enable --now vnstat 1> /dev/null
sudo systemctl enable --now irqbalance 1> /dev/null
sudo systemctl start modprobe@configfs.service 1> /dev/null
sudo systemctl start systemd-zram-setup@zram0.service 1> /dev/null
sudo systemctl start udisks2-zram-setup@zram0.service 1> /dev/null

### Enable opensitch servive only if opnsnitch are installed

if $opensnitch
then
  sudo systemctl enable --now opensnitchd 1> /dev/null
fi

## Save default Redsocks settings to the default system config file and startup redsocks daemon

sudo cp $src_dir/config/redsocks.conf /etc/redsocks.conf
sudo systemctl start redsocks 1> /dev/null

##################################################
## Kill all the simple run-scripts if running ###
#################################################

kill $(ps -aux | grep -E "bash $HOME/run-.*.sh" | grep -v grep | head --lines=-1 | awk '{ print $2}') &> /dev/null

#########################################################################################################################
######                                     ######                 ##################################################
####                   !! DISABLED !!    ####                     ### Ask to install extra unimportant packages ###
######                                     #####                  #################################################


###sudo bash -c `gnome-terminal -t 'Do you want to install libreoffice?' -- sudo bash $src_dir/install_unimportant.bash` &> /dev/null


######


##############################################################################
#### Open in browser the torproject checker url! See if tor is running!! #####
##############################################################################

librewolf 'about:preferences' 'about:support' 'about:performance' &> /dev/null

############################################
### Create Tor checking background loop ###
##                                     ###
#########################################

while true
do
  # Background check to look for tor service to open
  # webpages securely in librewolf ,-
  #
  ## -- Prevent sharing unnecassary stuff that could demasq your identity or your operating hostsystem to others,
  #      e.g. the Network IPS or the local Network Admin!

  sleep 3
  pidof tor &> /dev/null && librewolf 'https://check.torproject.org' 'https://mediatheksuche.de/' && sleep 9 && librewolf 'https://github.com/Nonie689/garuda-live.install-disk-fixer_modx/releases' &&  break
	  ## redo it every 3 seconds!
done &

########################################################
## At least show just some infos for usage at the!! ##
#####################################################
##

echo "[))> Run if you like to restart firevigeo:"
echo
echo "~/firevigeo -s"
echo
echo Finish building process!!
echo

##
###################################################################################
## Enhance sudo and su settings to more secure values for better livedisk usage ##
##################################################################################
##

#bash $src_dir/my_config/hotspot.sh

cp $src_dir/my_config/CREATE_AP.bash ~/
cp $src_dir/my_config/create_ap.conf ~/

sudo bash $src_dir/sudo-hardening-pro_tweaks.bash


#########################################################################################
###  Kill wayfire desktop! ###
################################

gnome-terminal --title="[Wayfire restarting in a few seconds! ]" -- sh -c "echo '' && echo 'Wayfire restarting in 15 seconds!' && echo 'Close this window to abort Wayfire closing and do it self!' && sleep 5 && echo 'Wayfire restarting in 10 seconds!' && sleep 5 && echo 'Wayfire restarting in  5 seconds!' && sleep 5 && killall wayfire"


#################################################################
#      _______________________________________________       #
##                                                           ##
##    ::Start greetd display manager in wayland mode!!::     ##
#             ---------------------------------              ####
#                                                             # 
#    ----------------------------------------------------    #
#   -                                                  -     #
##  - Run wayfire desktop after user loging are suceed -     #
##                                                           ####
#   ----------------------------------------------------     #
#                                                            # 
#     -- Wayfire uses wlroots-nvidia patched version  --     #
#                                                            ##
###                                                          #####
#        >> Desktop perfomance and stability are better <<    #######
#          =   crashing and freezing less often   =           ######
#                            xXx                              ###
#####        <<<<<<<<<<------------->>>>>>>>>>                #######
###               ----------(000}----------                     ###
##                 >>>>>---[[777]]]---<<<<<                   ##
###                                                        #####
######                                                  ##########
####################################################################
####
##
###

##########################################################
### !!! END OF THE GARUDA LIVE DISK MODER SCRIPT  !!! ###
#########################################################
