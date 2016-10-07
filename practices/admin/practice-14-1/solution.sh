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
source $bindir/wlspassword.sh

#Set practice folders
practice=$PWD
domain=/u01/domains/part2/wlsadmin

#Set deployer command line options
deployopts="-adminurl host01:7001 -username weblogic -password `cat /practices/part2/.wlspwd` -deploy -targets cluster1"
deploydir=$practice/solution

#Reset practice to starting state. Ensures no running servers and a clean domain.
./reset.sh

#Start AdminServer
startAdmin.sh

# create the coherenc cluster and add servers 1 and 2 as storage disabled members
wlst.sh createCoherenceCluster.py

#Configure Coherence cluster
wlst.sh createCohWeb.py

#deploy solution application
java weblogic.Deployer $deployopts $deploydir/ShoppingCart

#Put boot.properties in place for newly created server3 and server4 in domain
mkdir -p $domain/servers/server3/security
cp $practice/resources/boot.properties $domain/servers/server3/security
ssh host02 "mkdir -p $domain/servers/server4/security"
ssh host02 "cp $practice/resources/boot.properties $domain/servers/server4/security"

#Start server1
startServer1.sh

#Start server2
startServer2.sh

#Start server3
startServer3.sh

#Start server4
startServer4.sh

echo -e "\nWait for all servers to fully start, then continue with the next step.\n"



