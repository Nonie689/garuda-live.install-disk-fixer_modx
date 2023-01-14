#################################################
########### Define function section ############
###############################################

######## Set functions for fish

function killall_cmdline 
   kill $(ps -aux| grep -E "$argv" | grep -v "grep" | awk '{print $2}') || sudo kill $(ps -aux| grep run-wf-panel.sh | grep -v "grep" | awk '{print $2}')
end


function proxychains_opera 
    cat /etc/proxychains.opera-proxy.conf &>/dev/null && proxychains -q -f /etc/proxychains.opera-proxy.conf $argv
end


function mode2header
    #### For 16 Million colors use \e[0;38;2;R;G;Bm each RGB is {0..255}
    printf '\e[mR\n' # reset the colors.
    printf '\n\e[m%59s\n' "Some samples of colors for r;g;b. Each one may be 000..255"
    printf '\e[m%59s\n'   "for the ansi option: \e[0;38;2;r;g;bm or \e[0;48;2;r;g;bm :"
end


function mode2colors
    # foreground or background (only 3 or 4 are accepted)
    local fb set "$1"
    [[ $fb != 3 ]] && fb set 4
    local samples set (0 63 127 191 255)
    for         r in "${samples[@]}"; do
        for     g in "${samples[@]}"; do
            for b in "${samples[@]}"; do
                printf '\e[0;%s8;2;%s;%s;%sm%03d;%03d;%03d ' "$fb" "$r" "$g" "$b" "$r" "$g" "$b"
            done; printf '\e[m\n'
          echo
        done; printf '\e[m'
        echo
    done; printf '\e[mReset\n'
 
   for a in 0 1 4 5 7; do
              echo "a=$a " 
              for (( f=0; f<=9; f++ )) ; do
                      for (( b=0; b<=9; b++ )) ; do
                              #echo -ne "f=$f b=$b" 
                              echo -ne "\\033[${a};3${f};4${b}m"
                              echo -ne "\\\\\\\\033[${a};3${f};4${b}m"
                              echo -ne "\\033[0m "
                      done
              echo
              done
              echo
    done
    echo
end


function getansi_colors
   mode2header
   mode2colors 3
   mode2colors 4
end
