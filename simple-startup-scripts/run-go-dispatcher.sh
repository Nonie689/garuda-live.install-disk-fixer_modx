#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
  ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 
  exit
fi

command_val="go-dispatch-proxy -lport 4711 -tunnel 10.0.0.10:5090 10.0.0.10:5091 10.0.0.10:5092 10.0.0.10:5093 10.0.0.10:5094 10.0.0.10:5095 10.0.0.10:5096 10.0.0.10:5097 10.0.0.10:5098 10.0.0.10:5099 10.0.0.10:5100"
while [ True ] ; do
  if ! pidof go-dispatch-proxy ; then
     which go-dispatch-proxy &> /dev/null && gnome-terminal -t "[LOADBALANCER-UI]" -- $command_val
     wf-ctrl -i $(wf-info -l | grep  -E "LOADB" -B 4 | grep View|awk '{print $3}') --move 250,250 --switch-ws 0,1 
  else
    break
  fi
  sleep 1.0
done &
