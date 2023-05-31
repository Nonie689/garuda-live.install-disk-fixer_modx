

sudo pacman -Sy python librewolf tor proxychains conky --noconfirm
sudo pacman -S pikaur --noconfirm

pikaur -S redsocks-git go-dispatch-proxy-git --noconfirm --noedit

sudo systemctl start redsocks

cd ~/

git clone https://github.com/Nonie689/firevigeo-torloader 

cd ~/firevigeo-torloader 

sudo ./firevigeo.sh -s
