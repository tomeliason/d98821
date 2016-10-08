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

#This script is only run if the previous state is not retained from
#the previous practice13-01 practice. Running this resets everything to
#a state as though practice13-01 had been completed by the student unless
#it is executing the solution.

#Call the setup for the dependent practice to set up all dependencies.
cd $dependent
./solution.sh
cd $practice

echo -e "\nWait for all servers to fully start, then continue with the next step.\n"


