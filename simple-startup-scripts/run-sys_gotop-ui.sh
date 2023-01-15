#!/usr/bin/env bash

script_name=$(basename "$0")
#if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
#then
#   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print $2}')
#fi

command=gotop
command_val="$command  -l kitchensink -i $(netstat -r | awk ' {print $8}' | head -3 | tail -1)"
while [ True ] ; do
  if ! pidof $command &> /dev/null; then
     which $command &> /dev/null && gnome-terminal -t "[Monitor - System Stats]" -- $command_val || exit 1
  else
    sleep 1.0
    continue
  fi
  sleep 1.0
done &
