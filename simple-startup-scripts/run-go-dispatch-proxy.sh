#!/usr/bin/env bash

script_name=$(basename "$0")
ps -aux | grep -e "tor -f" | grep -v grep || ~/firevigeo -s
running_tor_ports=$()

command=go-dispatch-proxy
command_val=""

#if test $(ps -aux | grep -e 'tor.*-f.*/etc/tor/torrc.' | grep -v grep | awk '{print $2}' &> /dev/null)
#then
#   kill $(ps -aux | grep -e 'tor -f /etc/tor/torrc.' | grep -v grep| awk '{print $2}')
#fi

ps -aux | grep -e "tor -f" | grep -v grep &> /dev/null || ~/firevigeo -s

while [ True ] ; do
  if ! pidof $command &> /dev/null ; then
     gnome-terminal -t "[LOADBALANCER-UI]" -- $command -lport 4711 -tunnel $running_tor_ports $(grep SocksPort $(ps -aux | grep -e 'tor -f /etc/tor/torrc.' | grep -v grep | awk '{print $13}') | awk '{print $2}')
  else
    sleep 1.0
    continue
  fi
  sleep 1.0
done &
