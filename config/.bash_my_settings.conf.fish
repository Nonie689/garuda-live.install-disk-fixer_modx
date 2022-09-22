##########################################################################
################# MY EXPORTED ENVIROMENT VARIABLES !! ###################
########################################################################

export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_QPA_PLATFORM="wayland;xcb"
export WAYLAND_DISPLAY="$(find $XDG_RUNTIME_DIR/wayland-*|grep -v '.lock')"

##########################################################################
################# MY ALIAS AND CUSTOM FUNCTION AREA !! ##################
#######################################################################



alias adb="/opt/android-sdk/platform-tools/adb" 
alias axel="axel --ipv4 --num-connections=48 --no-clobber --alternate --percentage --timeout=6.3 --verbose "
alias bashconf_edit="nano ~/.bashrc_garuda"
alias bashconf_edit_own-settings="ln -s $HOME/.bash_load_my_settings.conf $HOME/.bash_load_my_settings.sh &> /dev/null ; sudo chown root:root $HOME/.bash_load_my_settings.sh && sudo nano $HOME/.bash_load_my_settings.sh"
alias bashconf_reload_own_settings="source /home/archlinuxuserx/.bash_load_my_settings.conf && echo Re-Loading my custom settigs!"
alias bashconf_reload="source ~/.bashrc_garuda ; printf 'Bashrc Config reloadet!\n\n  alias                    [shows all set aliases!]\n\n  bashconf_show_my_alias   [shows all set aliases and functions!]\n\' "
alias bashconf_my_alias="cat /home/archlinuxuserx/.bash_load_my_settings.conf | grep -E '(alias|function)'"
alias alias-ls="cat ~/.bash_load_my_settings.conf | grep -E '(alias|function)'"
alias ..-='cd -'
alias ...='cd ../..'
alias ..='cd ..'
alias df="df -ha --sync --print-type --total --local --si"
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fastboot="/opt/android-sdk/platform-tools/fastboot"
alias fgrep='fgrep --color=auto'
alias firevideo_change_to_gitworkdir="cd $HOME/.cache/firevigeo-torloader/ && printf '\nChange dir to:' && pwd"
alias firevigeo_exec_fresh-build="cd $HOME/.config/firevigeo-torloader/ && sudo ./firevigeo -s; cd -"
alias git_archconfig_cloud-repo="cd $HOME/my_arch_settings && printf '\nChange dir to: ' && pwd"
alias grep='grep --color=auto'
alias grub-update="sudo cp -rf /boot/grub/grub.cfg /boot/grub/grub_backup_$(date +%y.%m.%d@%H:%M).cfg && sudo update-grub --output=/boot/grub/grub.cfg"
alias helpme='cht.sh --shell'
alias hw='hwinfo --short'
alias journalctl_showboot="journalctl -b"
alias journalctl-show="journalctl -p 3 -xb"
alias ls="ls -lha --color=auto"
#alias opera-proxy="printf 'Start Opera!! DEAMON LOOP-MODE!!!\n_______________________\n' && sleep 1.3 && /home/archlinuxuserx/rerunner opera-proxy"
alias pacman_history="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias pacman_rankmirror_by-speed="sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist_$(date +%Y.%M.%D@%H:%M).backup && sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist_$(date +%Y.%M.%D@%H:%M).backup && proxychains -q -f  /etc/proxychains.opera-proxy.conf sudo rankmirrors -n 8 /etc/pacman.d/mirrorlist_$(date +%Y.%M.%D@%H:%M).backup > /etc/pacman.d/mirrorlist"
alias pacman_rankmirror_chaotic_by-speed="sudo cp /etc/pacman.d/chaotic-mirrorlist /etc/pacman.d/chaotic-mirrorlist_$(date +%Y.%M.%D@%H:%M).backup && sudo sed -i 's/^#Server/Server/' /etc/pacman.d/chaotic-mirrorlist_$(date +%Y.%M.%D@%H:%M).backup && proxychains -q -f  /etc/proxychains.opera-proxy.conf sudo rankmirrors -n 8 /etc/pacman.d/chaotic-mirrorlist_$(date +%Y.%M.%D@%H:%M).backup > /etc/pacman.d/chaotic-mirrorlist"
alias pacman-rm-db.lock="echo 'Removing:  /var/lib/pacman/db.lck' && sudo rm /var/lib/pacman/db.lck &> /dev/null"
alias pacman-fix-db.lock="echo 'Removing:  /var/lib/pacman/db.lck' && sudo rm /var/lib/pacman/db.lck &> /dev/null"
alias pacman_show-last-git_pkgs='pacman -Q | grep -i "\-git" | wc -l'
alias pacman_show-sized="expac -H M '%m\t%n' | sort -h | nl"
alias psmem-usage10='ps auxf | sort -nr -k 4 | head -10'
alias psmem-usage='ps auxf | sort -nr -k 4'
alias tarnow='tar -acf'
alias tb='nc termbin.com 9999'
alias untar='tar -zxvf'
alias vdir='vdir --color=auto'
alias wget='wget -c'



#################################################
########### define function section ############
###############################################

######## Set functions for fish

function check_pacman_db_lock 
   trap 'false' INT
   printf "\\033[s" && find /var/lib/pacman/db.lck &> /dev/null && printf "pacman db.lck exist! Proceed when database lock is unset!\\033[u" || false
end

function librewolf 
    bash -c "env GDK_BACKEND=wayland MOZ_ENABLE_WAYLAND=1 librewolf $argv"
    #bash -c "env MOZ_ENABLE_WAYLAND=1 librewolf $argv"
end

function pacman-recovery-db 
    command sudo pacman $argv --log /dev/null --noscriptlet --dbonly --overwrite "*" --nodeps --needed
end

function pacman 
    proxychains -q -f /etc/proxychains.opera-proxy.conf $(command pacman) $argv
end

function pacaur 
    check_pacman_db_lock && sleep 2.5 && pacaur $argv || sudo proxychains -q -f /etc/proxychains.opera-proxy.conf pikaur $argv
end

function pacaur-bin 
    check_pacman_db_lock && sleep 2.5 && pacaur-bin $argv || proxychains -q -f /etc/proxychains.opera-proxy.conf $(command pacaur) $argv
end

function picaur 
    check_pacman_db_lock && sleep 2.5 && picaur $argv || proxychains -q -f /etc/proxychains.opera-proxy.conf $(command pikaur ) $argv 
end

function pikaur 
    check_pacman_db_lock && sleep 2.5 && pikaur $argv || proxychains -q -f /etc/proxychains.opera-proxy.conf $(command pikaur ) $argv
end

function pacman-rm-force 
    check_pacman_db_lock && sleep 2.5 && pacman-rm-force $argv || sudo $(comman pacman) -Rdd $argv
end

function pacman_force_upgrade 
    check_pacman_db_lock && sleep 2.5 && pacman_force-succeed $argv || sudo /home/archlinuxuserx/rerunner proxychains -q -f /etc/proxychains.opera-proxy.conf $(command pacman) -Syu --noconfirm $argv
end

function pacman-del_orphaned_packages 
    check_pacman_db_lock && sleep 2.5 && pacman-del_orphaned_packages $argv || printf "Do you want to delete this packages???\n\n" && bash -c "$(command pacman) -Qtdq" && sudo $(command pacman) -Rns $(bash -c "$(command pacman) -Qtdq") --confirm
end

