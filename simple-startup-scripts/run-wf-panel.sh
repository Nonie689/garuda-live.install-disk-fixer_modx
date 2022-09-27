#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
   kill $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1| awk '{print 2}')
fi

killall wf-panel
command_val="wf-panel"
while [ True ] ; do
  if ! pidof wf-panel; then
    $command_val
  else
    continue
  fi
  sleep 1.0
done &
