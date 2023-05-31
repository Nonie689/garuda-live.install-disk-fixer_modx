#!/bin/bash

###
########################################################################
 #### Script startup init Area -- set some base variable and options ####
   #####################################################################
####
##########
##
###################################
  ##########################################################
####



trap "exit 130" INT
LC_ALL=C
src_dir="$(dirname $(realpath $0))"

####################################################################

  #######################################
#### Tweak gnome-terminal config setup ####
  ########################################

  ###############################
####   ----------------------------      ####
####     Infos to do it manually      #####
####       to edit or debug      ######
  ##################################
           ################
               ##########




##############################################################
##
# Save all settings from dconf folder as bkp backup-file!!
#
###### dconf dump /org/gnome/terminal/legacy/ > ./config/gsettings_gnome-terminal.bkp

# Manually load new custimized gnome-terminal settings
#
# dconf load /org/gnome/terminal/legacy/ < ./config/gsettings_gnome-terminal.bkp
#

############
##############################################################
#####


# Load my designed gnome-terminal optionbs setup

dconf load /org/gnome/terminal/legacy/ < $src_dir/config/gsettings_gnome-terminal.bkp



############
##############################################################
#####


  #############################
#### END OF SCRIPT INIT AREA ####
  #############################


##########
################################
######################
###



   ###################################################
##########################################
##                                      ##
# Change basic important setup options   #
 ###                                      ##
   ##########################################

sudo bash $src_dir/my_config/change_timezone_keylang.bash

sudo cp $src_dir/config/wayfire.desktop /usr/share/wayland-sessions/wayfire.desktop
sudo cp $src_dir/config/wayfire-debug.desktop /usr/share/wayland-sessions/wayfire-debug.desktop

# Save my display settings to system
cp $src_dir/my_config/wlr-randr-multihead-my_own_config.bash ~/wlr-randr-multihead-my_own_config.bash


# Disable garuda pacman foreign.hook programm!
sudo mv /usr/share/libalpm/hooks/foreign.hook /usr/share/libalpm/hooks/foreign.hook.bac &> /dev/null
sudo mv /usr/share/libalpm/hooks/orphans.hook /usr/share/libalpm/hooks/orphans.hook.bac &> /dev/null


## Safe rofi config to garudauser .config folder
mkdir ~/.config/rofi/ &> /dev/null
cp $src_dir/config/config.rasi ~/.config/rofi/config.rasi


#
####
##


                    #### ###     # ## ## ### ####
                  ########### ####################

        ############################################################
     ###########################################################
   ##########################################################
#             ---########################---      #
#####################################################
 #                                                 #
  ###          !! Start the Main Area !!         ######
  #                                                #
#####################################################
      ####                                     ####
         #######################################
       #            ---xxxXxXxxx---            #
  ###########----------------------------#########
       ####################################
                   #################



############################################################################
############################################################################


echo " ---"
echo ' --- Garuda LiveCD running since - $(uptime -s)!!!'
echo " --- Change Garuda_wayfire LiveCD settings and configs!!"
echo

echo "[))> Changing config starting!!"


############################################################################
############################################################################

## Create sys pakmin user!

#net_pass="$(echo $(ip -o link show  $(netstat -r | awk ' {print $8}' | head -3 | tail -1) | awk '{ print $2 }')%%%$(ip -o link show  $(netstat -r | awk ' {print $8}' | head -3 | tail -1) | awk '{ print $17 }')| openssl dgst -sha256| awk '{ print $2 }')" 
#echo $net_pass > ~/.config/net_block

##sudo useradd --no-create-home pakmin 
##echo $net_pass | echo $net_pass)| sudo passwd pakmin
##sudo usermod -aG wheel pakmin


### Install modified desktop mimes to system!

./desktop-mime/install.sh

## Install custom wayfire settings !!!
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/wayfire* ~/.config/ &> /dev/null && echo Config wayfire.ini copied!)
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/wf-shell.ini ~/.config/wf-shell.ini &> /dev/null && echo "Config wf-shell.ini copied!" )
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/shortcut-* ~/.config/ &> /dev/null && echo "Keyboard layout changer copied!" )
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/vlcrc ~/.config/vlc/vlcrc &> /dev/null && echo VLC config vlcrc copied!)


## Changing various of password options !!!
cd /tmp

touch shadow.lck

current_date="$(ls /tmp -lha| grep shadow.lck | awk '{print $7 $8}' | awk -F ':' '{print $1 $2}')"
shadow_date="$(ls /etc/shadow -lha | awk '{print $7 $8}' | awk -F ':' '{print $1 $2}')"


if test ${shadow_date} -lt ${current_date}
then
   echo
   echo "Open password changing dialoge!"
   touch ~/.cache/passwd.lck &>/dev/null
   cat ~/.cache/passwd_init.lck &> /dev/null || nohup sudo bash -c `gnome-terminal -t 'Do you want to choose the password?' -- sudo bash $src_dir/change_password.bash garuda` &> /dev/null

   sleep 0.25
   touch ~/.cache/passwd_init.lck &>/dev/null
fi

while ! test -e ~/.cache/passwd.lck
do
   sleep 1
done

## Create garuda live-cd modx folders for correct usage!!

mkdir $src_dir/pacman-cache &>/dev/null
mkdir $src_dir/pikaur-cache &>/dev/null
mkdir $src_dir/log &>/dev/null
mkdir $src_dir/my_config &>/dev/null


# Creates persistent pacman log files!
touch ${src_dir}/log/pacman_persistent.log &> /dev/null
sudo touch /var/log/pacman.log &> /dev/null
mount | grep -E "log/pacman.log" &> /dev/null || sudo mount -o bind  ${src_dir}/log/pacman_persistent.log /var/log/pacman.log


# Create local pikaur cache folder to store packages in it!
mkdir ~/.cache/pikaur/ &>/dev/null

# Mount the persitent pikaur folder to the user folder!
mkdir ~/.cache/pikaur/ &> /dev/null
stat --file-system  $src_dir | grep -E "Type:"| grep -v fat &> /dev/null && ( mount | grep -E ".cache/pikaur" &> /dev/null || sudo mount --rbind $src_dir/pikaur-cache ~/.cache/pikaur/ )


###################################################

##
## Customize the pacman some configs
##


## Install custom bashrc settings !!!
cp -rf $src_dir/config/bashrc_* ~/

cat ~/.config/fish/config.fish | grep -E "source ~/bashrc_my_settings.conf"  &> /dev/null || ( bash -c "echo 'source ~/bashrc_my_settings.conf' >> ~/.config/fish/config.fish && echo 'source ~/bashrc_functions.fish' >> ~/.config/fish/config.fish && echo 'source ~/bashrc_my_settings.conf' >> ~/.bashrc && echo 'source ~/bashrc_functions.source' >> ~/.bashrc" )


# Modify gtk-3.0 global setting
echo "gtk-enable-primary-paste=true" >> ~/.config/gtk-3.0/settings.ini
sed -i "s/gtk-primary-button-warps-slider.*/gtk-primary-button-warps-slider=true/g" ~/.config/gtk-3.0/settings.ini
sed -i "s/gtk-font-name=.*/gtk-font-name=Liberation Mono,  14/g" ~/.config/gtk-3.0/settings.ini

sudo cp /usr/lib/systemd/system/gpm.service /usr/lib/systemd/system/gpm-mouse1.service
sudo sed -i "s/ExecStart=/usr/bin/gpm.*/ExecStart=/usr/bin/gpm -m /dev/input/mouse1 -t imps2/g" /usr/lib/systemd/system/gpm-mouse1.service
sudo systemctl enable --now gpm-mouse1


## Install htop config file and simple startup scripts !!!
cp -rf $src_dir/config/htop/ ~/config/
sudo cp -rf $src_dir/config/nanorc  /etc/nanorc

sudo mkdir /etc/opensnitchd/rules/ -p &> /dev/null
sudo mkdir ~/.config/opensnitch/ -p &> /dev/null
mount | grep -E ".config/opensnitch" &> /dev/null || sudo mount --rbind $src_dir/config/opensnitch/ ~/.config/opensnitch/
mount | grep -E "/etc/opensnitchd/rules" &> /dev/null || sudo mount --rbind $src_dir/config/opensnitch/rules /etc/opensnitchd/rules/

# Copy pacman.conf to my local config folder!
cp -rf  $src_dir/config/pacman.conf $src_dir/my_config

# Modify my new pacman.conf!
sed -i "s/ParallelDownloads.*/ParallelDownloads = 16/g" $src_dir/my_config/pacman.conf
sed -i "s|LogFile.*|LogFile = /var/log/pacman.log|g" $src_dir/my_config/pacman.conf
stat --file-system  $src_dir | grep -E "Type:"| grep -v fat &> /dev/null && sed -i "s|CacheDir.*|CacheDir = ${src_dir}/pacman-cache/|g" $src_dir/my_config/pacman.conf

# Save the new modified pacman.conf to system configs to use them!
sudo cp $src_dir/my_config/pacman.conf /etc/pacman.conf


# Copy needet simple-startup-scripts to user base folder!
cp -rf $src_dir/simple-startup-scripts/* ~/
chmod +x ~/run-*
chmod +x ~/start_all_runner.sh
chmod +x ~/firevigeo


## Install proxychain config with opera-proxy proxy for it!!!
sudo cp -rf $src_dir/config/proxychains.opera-proxy.conf /etc/ &> /dev/null


## Install suway - qt/no-xorg-display error workaround to run graphical tools with admin rights!!
sudo cp -rf $src_dir/suway /usr/bin/ &> /dev/null && sudo chmod +x /usr/bin/suway

cp $src_dir/config/yakuakerc ~/.config/yakuakerc
cp $src_dir/config/yakuake.notifyrc  ~/.config/yakuake.notifyrc
mkdir ~/.local/share/konsole/
cp $src_dir/config/My_conf-RC.profile ~/.local/share/konsole/My_conf-RC.profile



## Install wayfire crosshair shortcut toolset !!!
ls ~/.cache/config_changed.lck &> /dev/null || ( sudo cp -rf $src_dir/config/command_switch_crossair-visibility /usr/bin/ && sudo chmod +x /usr/bin/command_switch_crossair-visibility )
ls ~/.cache/config_changed.lck &> /dev/null || ( sudo cp -rf $src_dir/config/command_switch_crossair-set_randomcolor /usr/bin/ && sudo chmod +x /usr/bin/command_switch_crossair-set_randomcolor )
ls ~/.cache/config_changed.lck &> /dev/null || ( sudo cp -rf $src_dir/config/command_switch_crossair-auto /usr/bin/ && sudo chmod +x /usr/bin/command_switch_crossair-auto )


## Install librewolf addons !!!
echo "[))> Installing LibreWolf AddOns!!"
ls ~/.cache/config_changed.lck &> /dev/null || sudo mkdir -p /usr/lib/librewolf/browser/extensions

cd $src_dir/Librewolf-extensions
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -rf $src_dir/config/pacaur/ /etc/xdg/
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f export_cookies_txt-0.3.2.xpi "/usr/lib/librewolf/browser/extensions/{36bdf805-c6f2-4f41-94d2-9b646342c1dc}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f videos_hls_m3u8_mp4_downloader-1.1.5.xpi "/usr/lib/librewolf/browser/extensions/meetsingletoo@gmail.com.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f foxyproxy_standard-7.5.1.xpi "/usr/lib/librewolf/browser/extensions/foxyproxy@eric.h.jung.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f print_edit_we-29.1.xpi "/usr/lib/librewolf/browser/extensions/printedit-we@DW-dev.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f temporary_containers-1.9.2.xpi "/usr/lib/librewolf/browser/extensions/{c607c8df-14a7-4f28-894f-29e8722976af}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f tranquility_1-3.0.24.xpi "/usr/lib/librewolf/browser/extensions/tranquility@ushnisha.com.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f youtube_recommended_videos-1.6.1.xpi "/usr/lib/librewolf/browser/extensions/myallychou@gmail.com.xpi"


echo "[))> Installing LibreWolf AddOns done!!"
echo
echo "[))> All done!!"
echo

touch ~/.cache/config_changed.lck
#dconf load / <
