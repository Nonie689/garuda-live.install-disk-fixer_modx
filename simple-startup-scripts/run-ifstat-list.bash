
ifstat  | head --lines=+2
echo

while true; do
  printf "$(date +%T)  $(ifstat  | grep enp | awk '{print $9}')\n"
  sleep 0.9
done
