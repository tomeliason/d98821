#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

. ../common/common.properties
. ../common/common.sh

createJDBCDataSource() {
    
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    source $WL_HOME/server/bin/setWLSEnv.sh
    
    java weblogic.WLST create_data_source.py

    ssh -T -O "exit" remotehost-proxy

}

if [ ${0##*/} == "solution.sh" ] ; then

createJDBCDataSource

fi