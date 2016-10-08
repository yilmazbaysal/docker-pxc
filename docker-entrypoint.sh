#!/bin/bash
set -eo pipefail

# SST_USER PASS must be the same across all the nodes.
if [[ -z $SST_USER_PASS ]]; then
	echo "SST_USER_PASS must be set for master node."
	exit 1
fi

########## Set my.cnf files accordingly ##########
IP="$(hostname -i)"
MY_CONFIG_FILE="/etc/mysql/my.cnf"

# Set 'wsrep_node_address' to the ip address of the current node
sed -i '22i\wsrep_node_address='$IP $MY_CONFIG_FILE 
sed -i '23d' $MY_CONFIG_FILE


if [[ $MASTER ]]; then  # If the node is master
	service mysql bootstrap-pxc

	mysql -e "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY '"$SST_USER_PASS"';"
	mysql -e "GRANT PROCESS, RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"

else # If the node is a member
	service mysql start
fi

bash

