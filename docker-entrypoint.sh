#!/bin/bash
set -eo pipefail

########## Set my.cnf files accordingly ##########
MY_CONFIG_FILE="/etc/mysql/my.cnf"

# Set 'wsrep_cluster_address' to given list of ip adresses
if [[ $IP_ADDRESSES ]]; then
	sed -i 's/^wsrep_cluster_address=.*/wsrep_cluster_address=gcomm:\/\/'"$IP"','"$IP_ADDRESSES"'/' $MY_CONFIG_FILE
fi

# Set 'wsrep_node_address' to the ip address of the current node
sed -i 's/^wsrep_node_address=.*/wsrep_node_address='"$IP"'/' $MY_CONFIG_FILE
##################################################

bash