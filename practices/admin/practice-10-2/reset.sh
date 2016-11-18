#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# reset deploying an application with weblogic server console

source `pwd`/.remove_data_source

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "reset.sh" ] ; then

        echo ">>> Resetting the practice environment for Practice 10-2"

        echo ">>> "
	deleteJDBCDataSource_AuctionDatabase
        
        echo ">>> Practice 10-2 environment has been reset."

fi
