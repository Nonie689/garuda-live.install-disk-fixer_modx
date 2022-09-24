

while true
do
	for nohup_exec in $(printf 'nohup %s &/dev/null & \n' ~/run-*)
	do
	   bash -c "$nohup_exec" &> /dev/null &
	done

	sleep 45
done 
