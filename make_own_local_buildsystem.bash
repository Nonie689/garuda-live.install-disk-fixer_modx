git clone --depth=1 https://github.com/archlinux/aur; cd aur
git remote set-branches --add origin package_name
git fetch
git checkout package_name
