
src_dir="$(dirname $(realpath $0))"  

echo
echo "Fixing wayfire no cursors Problem tool !!"
echo

sudo cp $src_dir/config/wayfire.desktop /usr/share/wayland-sessions/wayfire.desktop
