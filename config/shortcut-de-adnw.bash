killall wcm

sed -i "s/xkb_layou.*/xkb_layout = de/g" ~/.config/wayfire.ini
sed -i "s/xkb_option.*/xkb_options = compose:rctrl/g" ~/.config/wayfire.ini
sed -i "s/xkb_varian.*/xkb_variant = adnw/g" ~/.config/wayfire.ini
