#!/usr/bin/env bash


command=wf-panel
command_val="$command"
#script_name=$()

#if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
#then
#   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print $2}')
#fi

sleep 16

killall $command_val
while [ True ] ; do
  if ! test pidof $command_val &> /dev/null; then
    which $command && $command_val || exit 1
  else
    sleep 1.0
    continue
  fi
  sleep 1
done &
