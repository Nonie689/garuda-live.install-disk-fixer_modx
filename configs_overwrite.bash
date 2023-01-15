
trap "exit 130" INT
LC_ALL=C
src_dir="$(dirname $(realpath $0))"
export WAYLAND_DISPLAY="wayland-1"

sudo cp $srcdir/config/wayfire.desktop /usr/share/wayland-sessions/wayfire.desktop

echo
echo " --- Garuda LiveCD ModX config changer tool!!"
echo
echo
echo "[))> Changing config starting!!"

## Create sys pakmin user!

#net_pass="$(echo $(ip -o link show  $(netstat -r | awk ' {print $8}' | head -3 | tail -1) | awk '{ print $2 }')%%%$(ip -o link show  $(netstat -r | awk ' {print $8}' | head -3 | tail -1) | awk '{ print $17 }')| openssl dgst -sha256| awk '{ print $2 }')" 
#echo $net_pass > ~/.config/net_block

##sudo useradd --no-create-home pakmin 
##echo $net_pass | echo $net_pass)| sudo passwd pakmin
##sudo usermod -aG wheel pakmin


## Install custom wayfire settings !!!
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/wayfire* ~/.config/ &> /dev/null && echo Config wayfire.ini copied!)
ls ~/.cache/config_changed.lck &> /dev/null || ( cp config/wf-shell.ini ~/.config/wf-shell.ini &> /dev/null && echo "Config wf-shell.ini copied!" )


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
   cat ~/.cache/passwd_init.lck &> /dev/null || sudo bash -c `nohup gnome-terminal -t 'Do you want to choose the password?' -- bash $src_dir/change_password.bash $LOGNAME` &>/dev/null &
   
   sleep 0.25
   touch ~/.cache/passwd_init.lck &>/dev/null
fi

while ! test -e ~/.cache/passwd.lck
do
   sleep 1
done

## Create garuda live-cd modx folders

mkdir $src_dir/pacman-cache &>/dev/null
mkdir $src_dir/log &>/dev/null
mkdir $src_dir/my_config &>/dev/null


touch ${src_dir}/log/pacman.log
sudo touch /var/log/pacman.log

## Change pacman some configs

cp -rf  $src_dir/config/pacman.conf $src_dir/my_config

sudo sed -i "s/ParallelDownloads.*/ParallelDownloads = 16/g" $src_dir/my_config/pacman.conf
sed -i "s|#LogFile.*|LogFile = ${src_dir}/log/pacman.log|g" $src_dir/my_config/pacman.conf
sed -i "s|LogFile.*|LogFile = ${src_dir}/log/pacman.log|g" $src_dir/my_config/pacman.conf
sed -i "s|CacheDir.*|CacheDir = ${src_dir}/pacman-cache/|g" $src_dir/my_config/pacman.conf

# Add local pacman repo-fs
#cat $src_dir/my_config/pacman.conf || pacman-cache &> /dev/null || echo -e "[LocalCache]\nSigLevel = Never\nServer = file:///${src_dir}/pacman-cache" $src_dir/my_config/pacman.conf



sudo cp $src_dir/my_config/pacman.conf /etc/pacman.conf

## Install custom bashrc settings !!!
cp -rf $src_dir/config/bashrc_* ~/ 
cat ~/.config/fish/config.fish | grep -E "source ~/bashrc_my_settings.conf"  &> /dev/null || ( bash -c "echo 'source ~/bashrc_my_settings.conf' >> ~/.config/fish/config.fish && echo 'source ~/bashrc_functions.fish' >> ~/.config/fish/config.fish && echo 'source ~/bashrc_my_settings.conf' >> ~/.bashrc && echo 'source ~/bashrc_functions.source' >> ~/.bashrc" )

## Install htop config file and simple startup scripts !!!
cp -rf $src_dir/config/htop/ ~/config/
sudo cp -rf $src_dir/config/nanorc  /etc/nanorc
cp -rf $src_dir/config/opensnitch/ ~/.config/

cp -rf $src_dir/simple-startup-scripts/* ~/
chmod +x ~/run-*
chmod +x ~/start_all_runner.sh
chmod +x ~/firevigeo

## Install proxychain config with opera-proxy proxy for it!!!
sudo cp -rf $src_dir/config/proxychains.opera-proxy.conf /etc/ &> /dev/null

## Install waysudo - qt/no-xorg-display error workaround to run graphical tools with admin rights!!
sudo cp -rf $src_dir/waysudo /usr/bin/ &> /dev/null && sudo chmod +x /usr/bin/waysudo

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
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f i_dont_care_about_cookies-3.4.2.xpi "/usr/lib/librewolf/browser/extensions/jid1-KKzOGWgsW3Ao4Q@jetpack.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f mediareload-4.0.xpi "/usr/lib/librewolf/browser/extensions/{4b1fee76-664e-4093-beee-0c2c4dcfecc1}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f print_edit_we-29.1.xpi "/usr/lib/librewolf/browser/extensions/printedit-we@DW-dev.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f temporary_containers-1.9.2.xpi "/usr/lib/librewolf/browser/extensions/{c607c8df-14a7-4f28-894f-29e8722976af}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f tranquility_1-3.0.24.xpi "/usr/lib/librewolf/browser/extensions/tranquility@ushnisha.com.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f youtube_recommended_videos-1.6.1.xpi "/usr/lib/librewolf/browser/extensions/myallychou@gmail.com.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f videospeed-0.6.3.3.xpi "/usr/lib/librewolf/browser/extensions/{7be2ba16-0f1e-4d93-9ebc-5164397477a9}.xpi"
ls ~/.cache/config_changed.lck &> /dev/null || sudo cp -f video_downloader_profession-2.0.9.xpi "/usr/lib/librewolf/browser/extensions/{7be2ba16-0f1e-4d93-9ebc-5164397477a9}.xpi"
echo "[))> Installing LibreWolf AddOns done!!"
echo
echo "[))> All done!!"
echo

touch ~/.cache/config_changed.lck
#dconf load / <
