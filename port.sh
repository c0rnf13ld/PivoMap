#!/bin/bash

function ctrlC {
	echo -e "\n[*] Exiting...\n"
	tput cnorm; exit
}

trap ctrlC INT

if [ ${#} -eq 0 ]; then
	echo -e "\nUsage: $(basename $0) <top-port-range-to-scan>\n"
	tput cnorm; exit
fi

declare -i top_port_range=$1

echo -e "[*] Capturing output of ./host.sh"

output=$(./host.sh 2>&1)
active_hosts_scan=($(echo "$output" | grep -P ".*\[ACTIVE\]" | awk '{print $1}'))

for active_host in ${active_hosts_scan[@]}; do
	./scan.sh -H $active_host -p $top_port_range
done
