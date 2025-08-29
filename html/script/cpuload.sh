#!/bin/bash
echo "Content-type: text/plain"
echo ""
#while true; do
cpu_usage=$(grep 'cpu ' /proc/stat)
user=$(echo "$cpu_usage" | awk '{print$2}')
system=$(echo "$cpu_usage" | awk '{print$4}')
idle=$(echo "$cpu_usage" | awk '{print$5}')

cpu=$(echo "scale=7; ($user+$system)/($user+$system+$idle)*100" | bc)
echo "$user"
echo "$system"
echo "$idle"
echo "$cpu"


#sleep 1
#done
#echo "script works"
