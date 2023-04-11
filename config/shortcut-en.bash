killall wcm

sed -i "s/xkb_layou.*/xkb_layout = us/g" ~/.config/wayfire.ini
sed -i "s/xkb_option.*/xkb_options = compose:rctrl/g" ~/.config/wayfire.ini
sed -i "s/xkb_varian.*/xkb_variant =/g" ~/.config/wayfire.ini
