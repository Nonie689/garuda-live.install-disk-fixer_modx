
echo
echo "Refreshing keyrings -- forced mode!!"
echo
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populat
sudo pacman -Sy archlinux-keyring chaotic-keyring --noconfirm

echo
echo "All done!!"
echo

