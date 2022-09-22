#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
  ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1
  exit
fi

command_val="watch -n 20 vnstat -i $(netstat -r | awk ' {print $8}' | head -3 | tail -1)"
while [ True ] ; do
  if test $(ps -aux | grep -E "watch .*vnstat -i" | grep -v grep | wc -l) -lt 1 ; then
    which vnstat &> /dev/null && gnome-terminal -t"[NETTRAFFIC-TOTAL-STAT]" -- $command_val
    wf-ctrl -i $(wf-info -l | grep  -E "NETTRAFFIC-TOTAL-STAT" -B 4 | grep View|awk '{print $3}') --move 250,250 --switch-ws 1,3
  else
    break
  fi
  sleep 0.5
done &
