src_dir="$(dirname $(realpath $0))"

cp -rf ~/.config/opensnitch/ $src_dir/config/ && printf "\nAll Opensnitch settings saved to config folder:\n\n-----------------------------------------------\n\n~> garuda-live.install-disk-fixer_modx [git clone]\n\nBackup-folder: config/opensnitch/\n\n]" || printf "\nFailed to copy opensnitch settings from userdir!! \n\n"
