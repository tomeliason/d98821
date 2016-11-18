#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    echo ">>> Executing solution for Practice 22-1"

    ./setup.sh
    deployApplication_SimpleAuctionWebAppDb

    echo ">>> The solution for Practice 22-1 has been completed."

fi
