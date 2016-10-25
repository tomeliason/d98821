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

#Reset practice to starting state. Ensures no running servers and a clean domain.
./reset.sh

#Start AdminServer
startAdmin.sh

echo -e "\nWait for all servers to fully start, then continue with the next step.\n"


