
default_ifname="$(netstat -r | awk ' {print $8}' | head -3 | tail -1)"
default_ip_addr="$(ip a | grep ${default_ifname} | tail -1| awk '{print $2}')"
default_broadcast_addr="$(ip a | grep ${default_ifname} | tail -1| awk '{print $4}')"
default_gateway="$(ip route | head -1  | awk '{print $3}')"


function spoof_device_mac {
    sudo ip link set dev $1 down
    sudo sudo sudo macchanger -A -r $1
    sudo ip link set dev $1 up
}

function spoof_all_net_devs {
   ## Change on every interface the mac address
   for net_dev in $(ip link | awk -v n=2 'NR%n==1' | awk -F ':' '{print $2}' | grep -v lo)
   do
   while true
   do
      printf "[))> Should the public MAC Address spoofed on Network Interface: $net_dev (yes/no): "
        read yn
           case $yn in
                yes|y ) echo;echo "Changing the MAC Address of: $net_dev";echo;
                        spoof_device_mac $net_dev;echo;
                        break ;;
                no|n )  continue ;;
                * ) echo invalid response;
                    echo ;;
           esac
        done
   done

}

## Init and prepare area

pacman -Q pikaur-git &>/dev/null || sudo pacman -S pikaur-git --noconfirm
pacman -Q macchanger &>/dev/null || pikaur -S macchanger hostapd-mana linux-wifi-hotspot --noedit --noconfirm


sudo rfkill unblock wifi
spoof_all_net_devs


## Hotspot creation main area

echo
echo Enter Hotspot name!
read hotname
echo Enter Hotspot passphrase!
read hotphrase

echo Passphrase for $hotname is: $hotpass
echo
echo Running:
echo -e "[Unit]\nBindsTo=sys-subsystem-net-devices-wlan0.device\nAfter=sys-subsystem-net-devices-wlan0.device" > /etc/systemd/system/hostapd.service.d/override.conf
cat /etc/systemd/system/hostapd.service.d/override.conf

echo
echo
sudo sysctl net.ipv4.tcp_window_scaling=0 & >/dev/null 
sudo sysctl -a | grep -E "net.ipv4.ip_forward = 1" &> /dev/null || sysctl net.ipv4.ip_forward=1 &> /dev/null
cmd_let_create_ap="sudo create_ap -m nat $(ip addr| grep wlp | awk '{print $2}'| awk -F ':' '{print $1}') $default_ifname $hotname $hotphrase --isolate-clients --ieee80211ac --ieee80211n --country DE -d --no-haveged --fix-unmanaged --logfile /var/log/hotspot.log --pidfile /run/hotspot.pid --daemon"
echo $cmd_let_create_ap
$cmd_let_create_ap 1> /dev/null &


sudo iptables -t nat -A POSTROUTING -o $default_ifname -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $(ip addr| grep wlp | awk '{print $2}'| awk -F ':' '{print $1}')  -o $default_ifname -j ACCEPT


sudo iwconfig $(iw dev | grep Interface | awk  '{print $2}') channel auto
sudo iw $(iw dev| grep -E "phy#(0|1|2|3|4|5|6|7|8|9)+") set frag 512
sudo iw $(iw dev| grep -E "phy#(0|1|2|3|4|5|6|7|8|9)+") set rts 500
sudo iw dev $(iw dev | grep Interface | awk  '{print $2}') set power_save off
