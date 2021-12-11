#!/bin/sh

PARAMETER_COUNT=$#
MAIN_SWITCH=$1
PATH_TO_PF_CONF=$2
INTERFACE="en0"
PROXY_HOST="127.0.0.1"
PROXY_PORT=8088
HELP_MSG="usage: $0 [-ld] [file...] \n\t -f <file> - loads the given pf.conf file from the specific location \n\t -d (default) - it creates a pf_custom.conf file and loads it with the default forwarding rules"

check_arg_list() {
	if [ "$PARAMETER_COUNT" == 0 ]; then
		echo "$HELP_MSG"
		exit 0
	elif [[ "$MAIN_SWITCH" != "-f" && "$MAIN_SWITCH" != "-d" ]]; then
		echo "$HELP_MSG"
		exit 0
	fi
}

config_ip_forward() {
	echo "[+] Enabling IPv4 and IPv6 forwarding...\n"

	sudo sysctl net.inet.ip.forwarding=1
	sudo sysctl net.inet6.ip6.forwarding=1
}


load_config_file() {
	echo "\n[+] Loading Packer Filter config file...\n"
	sudo pfctl -f $PATH_TO_PF_CONF
}

creating_config_file() {
	echo "\n[+] Creating and loading Packer Filter config file...\n"
	echo "rdr pass on $INTERFACE inet proto tcp to any port {80, 443} -> $PROXY_HOST port $PROXY_PORT" > pf_custom.conf
	sudo pfctl -f ./pf_custom.conf
}

handle_args() {
	if [ "$MAIN_SWITCH" == "-f" ]; then
		load_config_file
	elif [ "$MAIN_SWITCH" == "-d" ]; then
		creating_config_file
	fi
}

perform_postjobs() {
	echo "\n[+] Turning ON Packet Filter...\n"
	sudo pfctl -e

	echo "\n[+] Checking pf configuration:\n"
	sudo pfctl -s all
}

check_arg_list
config_ip_forward
sleep 3
handle_args
sleep 3
perform_postjobs