#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print 2}')
fi

command_val="opera-proxy"
while [ True ] ; do
  if ! pidof opera-proxy ; then
     which $command_val &> /dev/null &&  gnome-terminal -t "[Opera Proxy]" -- opera-proxy
     wf-ctrl -i $(wf-info -l | grep  -E "Opera Proxy" -B 4 | grep View|awk '{print $3}') --move 250,350 --switch-ws 0,1
  else
    continue
  fi
  sleep 1.0
done &
