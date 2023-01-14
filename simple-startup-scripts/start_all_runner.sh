

simple_runner_list="run-go-dispatcher.sh run-mako.sh run-opensnitch-ui.sh run-opera-proxy.sh run-sys_gotop-ui.sh run-vnstat-day.sh run-vnstat-live.sh run-waybar.sh run-wf-background.sh run-wf-panel.sh"


for runner in $simple_runner_list
do
  nohup ~/$runner &> /dev/null &
done
