#!/bin/bash

function ctrlC {
	echo -e "\n[*] Exiting...\n"
	tput cnorm; exit
}

trap ctrlC INT

hostname_hosts=($(hostname -I | tr ' ' '\n' | head -n -1 | cut -d "." -f 1-3 | grep -v ":"))

for host in ${hostname_hosts[@]}; do
 	./scan.sh -H $host.0
done
