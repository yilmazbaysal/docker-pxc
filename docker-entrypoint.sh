#!/bin/bash
set -eo pipefail

# SST_USER PASS must be the same across all the nodes.
if [[ -z $SST_USER_PASS ]]; then
	echo "SST_USER_PASS must be set for all nodes."
	exit 1
fi

# IP must be set the ip address of the host machine for publish.
if [[ -z $IP ]]; then
	IP="$(hostname -i)"
fi

########## Set my.cnf files accordingly ##########
MY_CONFIG_FILE="/etc/mysql/my.cnf"

# Set 'wsrep_cluster_address' to given list of ip adresses
if [[ $IP_ADDRESSES ]]; then
	sed -i 's/^wsrep_cluster_address=.*/wsrep_cluster_address=gcomm:\/\/'"$IP"','"$IP_ADDRESSES"'/' $MY_CONFIG_FILE
fi

# Set 'wsrep_node_address' to the ip address of the current node
sed -i 's/^wsrep_node_address=.*/wsrep_node_address='"$IP"'/' $MY_CONFIG_FILE

#Set 'wsrep_sst_auth' accordingly
sed -i 's/^wsrep_sst_auth=.*/wsrep_sst_auth="sstuser:'"$SST_USER_PASS"'"/' $MY_CONFIG_FILE
##################################################

# Start the mysql
if [[ ${MASTER^^} == TRUE ]]; then  # If the node is master
	service mysql bootstrap-pxc

	mysql -e "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY '"$SST_USER_PASS"';"
	mysql -e "GRANT PROCESS, RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"

else # If the node is a member
	service mysql start
fi

bash
