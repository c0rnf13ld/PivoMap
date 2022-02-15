#!/bin/bash

function ctrlC {
	echo -e "\n[*] Exiting...\n"
	tput cnorm; exit
}

trap ctrlC INT
function usage {
	cat << EOF
Usage:
	$(basename $0) -H <host> [-p <top-port-num>]

Options:
	-H		: Can be "192.168.0.0" or a specific host like "192.168.0.15"
	-p		: Can only be used when specifying a single host, not 192.168.0.0

EOF
	tput cnorm; exit
}

if [ ${#} -eq 0 ]; then
	usage
fi

function scanHost {
	separator=$(printf "+%30s+")
	echo -e "\n${separator// /-}"
	for host in ${hosts[@]}; do
		echo -e "\n[*] Scanning host: $host/24"; sleep 2
		host=$(echo $host | cut -d "." -f 1-3)
		for i in $(seq 1 254); do
			timeout 1 bash -c "ping -c 1 $host.$i" &> /dev/null && echo -e "\t$host.$i\t[ACTIVE]"&
		done; wait
	done; wait
}

function scanPorts {
	separator=$(printf "+%30s+")
	echo -e "\n${separator// /-}"
	echo -e "\n[*] Port: 1-$port_range"
	echo -e "[*] Target: $hosts"; sleep 2
	echo -e "[*] Open Ports:"
	for port in $(seq 1 $port_range); do
		timeout 1 bash -c "echo '' > /dev/tcp/$hosts/$port" &> /dev/null && echo -e "\t$port\t[OPEN]" &
	done; wait
}

tput civis; while getopts ":H:p:h" arg; do
	case $arg in
		H) hosts=($OPTARG);;
		p) declare -i port_range=$OPTARG;;
		h) usage;;
		:) echo -e "[!] The -$OPTARG parameter expected an argument"; tput cnorm; exit;;
		?) echo -e "[!] The -$OPTARG parameter is not recognized within the script"; tput cnorm; exit;;
	esac
done

if [ $port_range ]; then
	scanPorts
	tput cnorm; exit
fi; if [ $hosts ]; then
	scanHost
	tput cnorm; exit
fi
