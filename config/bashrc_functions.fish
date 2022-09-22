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

