#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print 2}')
fi

command_val="mako --width 380  --icons 1"
while [ True ] ; do
  if ! pidof mako ; then
    $command_val
  else
    continue
  fi
  sleep 0.5
done &
