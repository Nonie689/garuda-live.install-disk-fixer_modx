killall wcm

sed -i "s/xkb_layou.*/xkb_layout = de/g" ~/.config/wayfire.ini
sed -i "s/xkb_option.*/xkb_options =/g" ~/.config/wayfire.ini
sed -i "s/xkb_varian.*/xkb_variant = neo/g" ~/.config/wayfire.ini
