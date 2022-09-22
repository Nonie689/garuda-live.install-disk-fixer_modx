
### To kill all simple run services
kill $(ps -aux | grep -E "run-" | grep -v "grep" | awk '{print $2}') &> /dev/null
