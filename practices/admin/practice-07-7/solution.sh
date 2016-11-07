#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# function to describe an environment using WLST
describeEnvironment() {
    
    echo "setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}
    ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}

    source $WL_HOME/server/bin/setWLSEnv.sh
        
    java weblogic.WLST describe_environment.py

    echo ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    echo "terminating ssh tunnel for WLST"

}

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    describeEnvironment

fi
