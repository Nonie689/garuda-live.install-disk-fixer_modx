#!/usr/bin/env bash

command=vnstat
command_val="${command} -l -i $(netstat -r | awk ' {print $8}' | head -3 | tail -1)"
script_name=$(basename "$0")
#if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
#then
#  kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print $2}')
#fi

kill $(ps -aux | grep ${command} | grep -v grep | awk 'print $2')
while [ True ] ; do
  if test $(ps -aux | grep -E "$command_val" | grep -v grep | wc -l) -lt 2; then
    gnome-terminal -t "[NETTRAFFIC-LIVESTAT]" -- $command_val
  else
    sleep 1.0
    continue
  fi
  sleep  1.0
done &
