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

#Set practice folders
dependent=$PWD/../practice11-01
practice=$PWD

#This script runs the solution for practice13-01 and then performs configuration for practice13-02

#Call the setup for the dependent practice to set up all dependencies.
cd $dependent
./solution.sh
cd $practice

#Configure auditing using WLST online because servers are running
wlst.sh createAuditProvider.py

#Restart servers because a provider was created
echo "Restarting servers to realize changes."
killServers.sh
startAdmin.sh
startServer1.sh

echo -e "\nWait for all servers to fully start, then continue with the next step.\n"


