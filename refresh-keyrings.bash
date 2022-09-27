
function forced-refresh {
	echo "[))> Using fallback -- [forced mode]--"
	echo

	sudo rm -rf /etc/pacman.d/gnupg
	sudo pacman-key --init
	sudo pacman-key --populat
	sudo pacman -Sy archlinux-keyring chaotic-keyring --noconfirm
}

echo
echo "Refresh keyrings!!"
echo

sudo pacman -Sy archlinux-keyring chaotic-keyring --noconfirm 2>/dev/null || forced-refresh

echo "[))> All done!!"
echo

