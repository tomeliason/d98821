#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------

bindir=/practices/part2/bin
source $bindir/checkoracle.sh
source $bindir/checkhost01.sh

practice=$PWD
domain=/u01/domains/part2/wlsadmin

#Reset practice to starting state. Ensures no running servers and a clean domain.
./reset.sh

#Start AdminServer
startAdmin.sh

# create the coherenc cluster and add servers 1 and 2 as storage disabled members
wlst.sh createCoherenceCluster.py

#Create WebLogic servers and cluster2
wlst.sh createServers3n4.py
mkdir -p $domain/servers/server3/security
cp $practice/resources/boot.properties $domain/servers/server3/security
ssh host02 "mkdir -p $domain/servers/server4/security"
ssh host02 "cp $practice/resources/boot.properties $domain/servers/server4/security"

#Start server1
startServer1.sh

#Start server2
startServer2.sh

echo -e "\nWait for all servers to fully start, then continue with the next step.\n"


