#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# setup script

# function to create a JDBC Data Source named jdbc.AuctionDB using WLST
createJDBCDataSource_AuctionDB() {
    
    echo ">>> Setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCShost}:${WLSAdminPort} opc@${JCShost}
    ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCShost}:${WLSAdminPort} opc@${JCShost}

    source $WL_HOME/server/bin/setWLSEnv.sh
    
    export DBCSURL="jdbc:oracle:thin:@DB:1521/PDB1.${identityDomain}.oraclecloud.internal"
    export DBCSAuctionUsername=ORACLE
    export DBCSAuctionPassword=ORACLE
        
    java weblogic.WLST create_data_source.py

    echo ssh -S jcs-ctrl-socket -O "exit" opc@${JCShost}
    ssh -S jcs-ctrl-socket -O "exit" opc@${JCShost}
    echo ">>> Terminating ssh tunnel for WLST"

}


# if this script is called as a main script, execute the function 
if [ ${0##*/} == "setup.sh" ] ; then

        echo ">>> Setting up the practice environment for Practice 11-2"

        echo ">>> Creating the data source"
        
        createJDBCDataSource_AuctionDB
        
        echo ">>> The data source has been created."
        
        echo ">>> Practice 11-2 environment has been setup."

fi
