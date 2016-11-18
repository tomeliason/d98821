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
function startSSHTunnel {

    echo "setting up ssh tunnelfor REST commands"
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy
    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy
}

function stopSSHTunnel {

    echo "terminating ssh tunnel for WLST"
    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy

}

function deleteJDBCDataSource_AuctionDatabase() {
    
    startSSHTunnel
    curl -v --user ${WLSUsername}:${WLSPassword} \
           -H X-Requested-By:MyClient \
           -H Accept:application/json \
	   -H Content-Type:application/json \
           -X DELETE http://localhost:7001/management/wls/latest/datasources/id/jdbc.AuctionDatabase  > /dev/null 2>&1
    stopSSHTunnel

}


# if this script is called as a main script, execute the function 
if [ ${0##*/} == "reset.sh" ] ; then

        echo ">>> Resetting the practice environment for Practice 10-1"

        echo ">>> deleting auction data source if found"
	deleteJDBCDataSource_AuctionDatabase
        
        echo ">>> Practice 10-1 environment has been reset."

fi
