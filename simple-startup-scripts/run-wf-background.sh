#!/usr/bin/env bash

command=wf-background
command_val="$command"
script_name=$(basename "$0")

#if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
#then
#   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print $2}')
#fi

while [ True ] ; do
  if ! pidof $command &> /dev/null; then
    $command_val
  else
    sleep 1.0
    continue
  fi
  sleep 1.0
done &
