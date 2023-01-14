cd ~/.cache

sudo pacman -Rdd manjaro-application-utility --noconfirm

sudo pacman -S base-devel lxqt gdm grim wf-recorder swaybg git wlroots --noconfirm
#sudo systemctl disable lightdm
#sudo systemctl enable gdm


https://aur.archlinux.org/bauerbill.git
https://aur.archlinux.org/pikaur.git

pikaur -S bauerbill yambar waybox

bauerbill --aur 


killall X

echo
echo Please re-login
echo
 
