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

#Set deployer command line options
deployopts="-adminurl host01:7001 -username weblogic -password `cat /practices/part2/.wlspwd` -deploy"
deploydir=$practice/resources

#Reset practice to starting state. Ensures no running servers and a clean domain.
./reset.sh

#Start AdminServer
startAdmin.sh

#Configure Coherence cluster
wlst.sh configureCoherenceCluster2.py

#deploy applications
java weblogic.Deployer $deployopts -targets server2 $deploydir/ExampleGAR.gar
java weblogic.Deployer $deployopts -targets server1 $deploydir/ExampleEAR.ear

echo -e "\nWait for all servers to fully start, then continue with the next step.\n"


