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

# Set 'wsrep_cluster_address' to given list of ip adresses
if [[ $IP_ADDRESSES ]]; then
	sed -i '10i\wsrep_cluster_address=gcomm://'$(hostname -i)','$IP_ADDRESSES $MY_CONFIG_FILE 
	sed -i '11d' $MY_CONFIG_FILE
fi

# Set 'wsrep_node_address' to the ip address of the current node
sed -i '22i\wsrep_node_address='$IP $MY_CONFIG_FILE 
sed -i '23d' $MY_CONFIG_FILE

#Set 'wsrep_sst_auth' accordingly
sed -i '31i\wsrep_sst_auth="sstuser:'$SST_USER_PASS'"' $MY_CONFIG_FILE 
sed -i '32d' $MY_CONFIG_FILE
########## Set my.cnf files accordingly ##########

if [[ $MASTER ]]; then  # If the node is master
	service mysql bootstrap-pxc

	mysql -e "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY '"$SST_USER_PASS"';"
	mysql -e "GRANT PROCESS, RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"

else # If the node is a member
	service mysql start
fi

bash
