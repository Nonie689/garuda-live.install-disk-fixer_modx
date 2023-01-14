echo
echo Install all depencies to use firevigeo !!
echo

pacman -Q pikaur-git &> /dev/null || sudo pacman -S pikaur --noconfirm
pacman -Q go &> /dev/null || sudo pacman -S go --noconfirm

pacman -Q redsocks-git &> /dev/null || pikaur -S --noconfirm --noedit rtl88x2bu-dkms-git go-dispatch-proxy-git tor conky proxychains-ng redsocks-git opera-proxy 
sudo modprobe 88x2bu
sudo systemctl start redsocks

echo
echo All done! Should working now
echo

cd ~
git clone https://github.com/Nonie689/opera-proxy.desktop || true

cd opera-proxy.desktop 

sudo make install

sleep 3

gtk-launch opera-vpn-network-proxy 

cd ~
git clone https://github.com/Nonie689/firevigeo-torloader || true

cd firevigeo-torloader 

sudo ./firevigeo.sh -s 9800 9867
