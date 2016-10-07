#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------

practicedir=/practices/part2/practice13-01
bindir=/practices/part2/bin
source $bindir/checkoracle.sh
source $bindir/checkhost01.sh
#
source $bindir/wlspassword.sh
#

#Set deployer command line options



#Reset practice to starting state.
./reset.sh 

#Start AdminServer
echo -e "\nStarting AdminServer\n"
startAdmin.sh

#Start managed servers
# not required for the partitioned work
#echo -e "\nStarting Managed Servers\n"
#startServer1.sh &
#startServer2.sh &
#sleep 60
wlspwd=`cat /practices/part2/.wlspwd` 
echo -e "\n Creating partition"
$MW_HOME/wlserver/common/bin/wlst.sh /practices/part2/practice13-01/createPartition.py `cat /practices/part2/.wlspwd`

#$echo -e "\n Restarting the admin server"
#Ensure we are starting with a clean shut down domain
$bindir/killServers.sh
ssh host02 'bash -c /practices/part2/bin/killServers.sh'
startAdmin.sh
$MW_HOME/wlserver/common/bin/wlst.sh /practices/part2/practice13-01/startPartition.py `cat /practices/part2/.wlspwd`

deployopts="-adminurl host01:7001/AuctionDP -username weblogic -password `cat /practices/part2/.wlspwd` -deploy "
deploydir=/practices/part2/apps

#This script is run after students have manually started the domain and before using the domain

#The solution script calls reset.sh before running this script to ensure a clean starting point

#Perform deployment tasks
echo -e "\nDeploying applications for this practice\n"
deployopts="-adminurl host01:7001 -partition exampleDP -username weblogic -password `cat /practices/part2/.wlspwd` -deploy "
deploydir=/practices/part2/apps
java weblogic.Deployer $deployopts $deploydir/ShoppingCart.war

