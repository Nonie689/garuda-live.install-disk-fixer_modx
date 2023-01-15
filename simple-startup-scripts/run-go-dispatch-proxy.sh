#!/usr/bin/env bash

script_name=$(basename "$0")
ls /etc/tor/torrc.* &> /dev/null || exit
running_tor_ports=$(grep SocksPort $(ps -aux | grep -e 'tor -f /etc/tor/torrc.' | grep -v grep | awk '{print $13}') | awk '{print $2}')

command=go-dispatch-proxy
command_val="$command -lport 4711 -tunnel $running_tor_ports"

#if test $(ps -aux | grep -e 'tor.*-f.*/etc/tor/torrc.' | grep -v grep | awk '{print $2}' &> /dev/null)
#then
#   kill $(ps -aux | grep -e 'tor -f /etc/tor/torrc.' | grep -v grep| awk '{print $2}')
#fi

while [ True ] ; do
  if ! pidof $command &> /dev/null ; then
     which $command &> /dev/null && gnome-terminal -t "[LOADBALANCER-UI]" -- $command_val
  else
    sleep 1.0
    continue
  fi
  sleep 1.0
done &
