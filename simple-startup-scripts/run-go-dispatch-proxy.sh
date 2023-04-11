#!/usr/bin/env bash

script_name=$(basename "$0")
running_tor_ports=$()

command="go-dispatch-proxy"
check_firevigeo="/home/$USER/firevigeo -s && sleep 3 && killall opera-proxy"
command_val=""

#if test $(ps -aux | grep -e 'tor.*-f.*/etc/tor/torrc.' | grep -v grep | awk '{print $2}' &> /dev/null)
#then
#   kill $(ps -aux | grep -e 'tor -f /etc/tor/torrc.' | grep -v grep| awk '{print $2}')
#fi

ps -aux | grep -e 'tor -f /etc/tor/torrc.' | grep -v grep &> /dev/null || gnome-terminal -t "[Launch Firevigeo]" -- $check_firevigeo

while [ True ] ; do
  if ! pidof $command &> /dev/null && pidof tor ; then
     gnome-terminal -t "[LOADBALANCER-UI]" -- $command -lhost 10.0.0.10 -lport 4711 -tunnel $(grep SocksPort $(ps -aux | grep -e 'tor -f /etc/tor/torrc.' | grep -v grep | awk '{print $13}') | awk '{print $2}')
  else
    sleep 1.0
    continue
  fi
  sleep 1.0
done &
