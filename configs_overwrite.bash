
trap "exit 130" INT
src_dir="$(dirname $(realpath $0))"   

echo
echo Changing the config!

## Create sys pakmin!

net_pass="$(echo $(ip -o link show  $(netstat -r | awk ' {print $8}' | head -3 | tail -1) | awk '{ print $2 }')%%%$(ip -o link show  $(netstat -r | awk ' {print $8}' | head -3 | tail -1) | awk '{ print $17 }')| openssl dgst -sha256| awk '{ print $2 }')" 
echo $net_pass > ~/.config/net_block

sudo useradd --no-create-home pakmin
(echo $net_pass | echo $net_pass ) | sudo passwd pakmin
sudo usermod -aG wheel pakmin
## Install custom wayfire settings !!!
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/wayfire* ~/.config/ &> /dev/null && echo Config wayfire.ini copied!)
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/wf-shell.ini ~/.config/wf-shell.ini &> /dev/null && echo Config wf-shell.ini copied!)

## Changing various of password options !!!
ls ~/.cache/config_changed.lck &> /dev/null || ( bash -c "nohup gnome-terminal -t 'Do you want to choose the password?' -- sudo bash change_password.bash $LOGNAME" &>/dev/null & ) && touch ~/.cache/passwd.lck &>/dev/null

while ! test -e ~/.cache/passwd.lck
do
   sleep 1
done

ls ~/.cache/config_changed.lck &> /dev/null || sleep 2 && rm ~/.cache/passwd.lck

## Install wayfire crosshair shortcut toolset !!!
ls ~/.cache/config_changed.lck &> /dev/null || ( sudo cp -rf config/command_switch_crossair-visibility /usr/bin/ && sudo chmod +x /usr/bin/command_switch_crossair-visibility )
ls ~/.cache/config_changed.lck &> /dev/null || ( sudo cp -rf config/command_switch_crossair-set_randomcolor /usr/bin/ && sudo chmod +x /usr/bin/command_switch_crossair-set_randomcolor )
ls ~/.cache/config_changed.lck &> /dev/null || ( sudo cp -rf config/command_switch_crossair-auto /usr/bin/ && sudo chmod +x /usr/bin/command_switch_crossair-auto )

## Install custom bashrc settings !!!
cp -rf config/bashrc_* ~/ 
cat ~/.config/fish/config.fish | grep -E "source ~/bashrc_my_settings.conf"  &> /dev/null || ( bash -c "echo 'source ~/bashrc_my_settings.conf' >> ~/.config/fish/config.fish && echo 'source ~/bashrc_functions.fish' >> ~/.config/fish/config.fish && echo 'source ~/bashrc_my_settings.conf' >> ~/.bashrc && echo 'source ~/bashrc_functions.source' >> ~/.bashrc" )

## Install htop config file and simple startup scripts !!!
cp -rf config/htop/ ~/config/
sudo cp -rf config/nanorc  /etc/nanorc 
cp -rf config/opensnitch/ ~/.config/ 

cp -rf simple-startup-scripts/* ~/
chmod +x ~/run-*
chmod +x ~/firevigeo

## Install proxychain config with opera-proxy proxy for it!!!
sudo cp -rf $src_dir/config/proxychains.opera-proxy.conf /etc/ &> /dev/null

## Install waysudo - qt/no-xorg-display error workaround to run graphical tools with admin rights!!
sudo cp -rf waysudo /usr/bin/ &> /dev/null && sudo chmod +x /usr/bin/waysudo

## Install librewolf addons !!!
echo
echo "Installing LibreWolf AddOns!"
echo
ls ~/.cache/config_changed.lck &> /dev/null || sudo mkdir -p /usr/lib/librewolf/browser/extensions 

cd Librewolf-extensions
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f export_cookies_txt-0.3.2.xpi "/usr/lib/librewolf/browser/extensions/{36bdf805-c6f2-4f41-94d2-9b646342c1dc}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f videos_hls_m3u8_mp4_downloader-1.1.5.xpi "/usr/lib/librewolf/browser/extensions/meetsingletoo@gmail.com.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f foxyproxy_standard-7.5.1.xpi "/usr/lib/librewolf/browser/extensions/foxyproxy@eric.h.jung.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f i_dont_care_about_cookies-3.4.2.xpi "/usr/lib/librewolf/browser/extensions/jid1-KKzOGWgsW3Ao4Q@jetpack.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f mediareload-4.0.xpi "/usr/lib/librewolf/browser/extensions/{4b1fee76-664e-4093-beee-0c2c4dcfecc1}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f print_edit_we-29.1.xpi "/usr/lib/librewolf/browser/extensions/printedit-we@DW-dev.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f temporary_containers-1.9.2.xpi "/usr/lib/librewolf/browser/extensions/{c607c8df-14a7-4f28-894f-29e8722976af}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f tranquility_1-3.0.24.xpi "/usr/lib/librewolf/browser/extensions/tranquility@ushnisha.com.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f youtube_recommended_videos-1.6.1.xpi "/usr/lib/librewolf/browser/extensions/myallychou@gmail.com.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f videospeed-0.6.3.3.xpi "/usr/lib/librewolf/browser/extensions/{7be2ba16-0f1e-4d93-9ebc-5164397477a9}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f video_downloader_profession-2.0.9.xpi "/usr/lib/librewolf/browser/extensions/{7be2ba16-0f1e-4d93-9ebc-5164397477a9}.xpi"
echo " --- Installing LibreWolf AddOns done!"
echo 
echo
echo Changing of config files finished!
echo

touch ~/.cache/config_changed.lck
#dconf load / < 
