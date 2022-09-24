#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
  kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print 2}')
fi

command_val="vnstat -l -i $(netstat -r | awk ' {print $8}' | head -3 | tail -1)"
while [ True ] ; do
  if test $(ps -aux | grep -E "$command_val" | grep -v grep | wc -l) -lt 2; then
    which vnstat &> /dev/null && gnome-terminal -t "[NETTRAFFIC-LIVESTAT]" -- $command_val
    wf-ctrl -i $(wf-info -l | grep  -E "NETTRAFFIC-LIVESTAT" -B 4 | grep View|awk '{print $3}') --move 250,250 --switch-ws 1,3
  else
    continue
  fi
  sleep 0.5
done &
