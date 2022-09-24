#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print 2}')
fi

command_val="gotop  -l kitchensink -i $(netstat -r | awk ' {print $8}' | head -3 | tail -1)"
while [ True ] ; do
  if ! pidof gotop; then
     which gotop &> /dev/null && gnome-terminal -t "[Monitor - System Stats]" -- $command_val
     wf-ctrl -i $(wf-info -l | grep  -E "Monitor - System Stats" -B 4 | grep View|awk '{print $3}') --move 250,250 --switch-ws 1,2
  fi
  sleep 1.0
done &
