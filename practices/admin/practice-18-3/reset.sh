#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------

#This script resets practice files, the domain, and the environment to its original state

bindir=/practices/part2/bin
source $bindir/checkoracle.sh
source $bindir/checkhost01.sh

#Handle args
#If -skip arg comes in this is called by cleanup.sh to cleanup the entire set of practices
#In this case, skip calling cleanup.sh because it is in charge already
if [ "$1" != "-skip" ]; then 
    #Reset original domain and env
    cleanup.sh
    echo -e "\nDomain, environment, and practice all reset to original state.\n"
fi

#Reset practice files



