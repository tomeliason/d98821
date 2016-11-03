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


# if this script is called as a main script, execute the function 
if [ ${0##*/} == "reset.sh" ] ; then

	echo ">>> Resetting the practice environment for $(basename $(pwd))"
        #echo "ssh -T -O "exit" remotehost-proxy"
	#ssh -T -O "exit" remotehost-proxy
	#echo "terminating ssh tunnel for WLST"
        echo ">>> $(basename $(pwd)) environment has been reset."

fi
