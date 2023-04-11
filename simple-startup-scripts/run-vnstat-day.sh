#!/usr/bin/env bash

script_name=$(basename "$0")
command=vnstat
command_val="watch -n 10 ${command}"


#if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
#then
#  kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print $2}')
#fi

kill $(ps -aux | grep -E "$command_val" | grep -v grep | awk '{print $2}')

while [ True ] ; do
 if test $(ps -aux | grep -E "$command_val" | grep -v grep | wc -l) -lt 1; then
     gnome-terminal -t '[VNSTAT-TOTAL]' --geometry=80x19 -- ${command_val}
    sleep 1.0
 else
    sleep 1.0
  fi
done &
