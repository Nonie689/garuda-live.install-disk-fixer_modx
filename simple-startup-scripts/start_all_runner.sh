#!/usr/bin/env bash

## Remove temparely -> run-opera-proxy.sh
simple_runner_list="run-go-dispatch-proxy.sh run-mako.sh run-opensnitch-ui.sh run-sys_gotop-ui.sh run-update_adlists.sh run-vnstat-day.sh run-waybar.sh run-wf-background.sh run-wf-panel.sh"


kill $(ps -aux | grep run-| awk '{print $2}')

for runner in $simple_runner_list
do
  ~/$runner &> /dev/null &
done &
