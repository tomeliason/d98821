#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# function to create a JDBC Data Source named jdbc.AuctionDB using WLST
createJDBCDataSource_AuctionDB() {
    
    echo "setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    source $WL_HOME/server/bin/setWLSEnv.sh
    
    java weblogic.WLST create_data_source.py

    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy
    echo "terminating ssh tunnel for WLST"

}

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    createJDBCDataSource_datasource1

fi