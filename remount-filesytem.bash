
while true
do
   for devices in $(mount | grep -E "/dev/sd|/dev/mapper"| awk '{print $1}')
   do
     sudo mount -o remount,rw $devices &>/dev/null
   done
sleep 2
done &
