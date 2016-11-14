#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------

# environment variables:
#   - JCSHost        - IP Address of the Admin Server
#   - WLSAdminHost   - 
#   - WLSDeployPort  - Port of the Admin Server - Administration Port
#   - WLSUsername    - Admin User
#   - WLSPassword    - Admin Password
#   - WLSClusterName - Target Cluster

practicedir=/practices/admin/practice-15-1

# function to create a partition using WLST
createPartition() {
    
    echo ">>> Setting up ssh tunnel for WLST"

    echo ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}
    ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}

    source $WL_HOME/server/bin/setWLSEnv.sh
        
    java weblogic.WLST createPartition.py

    echo ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    echo ">>> Terminating ssh tunnel for WLST"

}

# function to deploy the shopping cart application
deployShoppingCart() {
    
    echo ">>> Setting up ssh tunnel"

    echo ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}
    ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}

curl -v -u ${WLSUsername}:${WLSPassword} -H "X-Requested-By:MyClient" -H Accept:application/json -H Content-Type:multipart/form-data -F "model={name:'ShoppingCart',targets:['${WLSClusterName}']}" -F "deployment=@./ShoppingCart.war" -X POST http://localhost:${WLSAdminPort}/exampleDP/management/weblogic/latest/edit/partitions/exampleDP/resourceGroups/default/appDeployments

    echo ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}

    echo ">>> Terminating ssh tunnel"

}
# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    echo ">>> Executing solution for Practice 15-1"

    createPartition
    deployShoppingCart
        
    echo ">>> The solution for Practice 15-1 has been completed."

fi

