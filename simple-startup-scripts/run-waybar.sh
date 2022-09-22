#!/usr/bin/env bash

script_name=$(basename "$0")
if test $(ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1 | awk '{print $2}'| wc -l) -gt 1
then
  ps -ef | grep -E "$script_name" | grep -v grep | head --lines=-1
  exit
fi

command_val="waybar"
while [ True ] ; do
  if ! pidof waybar; then
    $command_val
  else
    break
  fi
  sleep 1.0
done &
