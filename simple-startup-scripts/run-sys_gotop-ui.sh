#!/usr/bin/env bash

script_name=$(basename "$0")
#if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
#then
#   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print $2}')
#fi

command=gotop
command_val="$command  -l kitchensink -i $(ip route  | awk '{print $5}' | head -1)"
while [ True ] ; do
  if ! pidof $command &> /dev/null; then
      gnome-terminal -t "[Monitor - System Stats]"  --geometry=180x40 -- $command_val
  else
    sleep 1.0
    continue
  fi
  sleep 1.0
done &
