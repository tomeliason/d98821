#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# function to deploy the benefits application to weblogic server
# environment variables:
#   - JCSHost        - IP Address of the Admin Server
#   - WLSDeployPort  - Port of the Admin Server - Administration Port
#   - WLSUsername    - Admin User
#   - WLSPassword    - Admin Password
#   - WLSClusterName - Target Cluster

deployApplication_benefits() {

    echo ">>> Setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy

    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy

curl -v -u ${WLSUsername}:${WLSPassword} -H "X-Requested-By:MyClient" -H Accept:application/json -H Content-Type:multipart/form-data -F "model={name:'benefits',targets:['${WLSClusterName}']}" -F "deployment=@./benefits.war" -X POST http://${WLSAdminHost}:${WLSDeployPort}/management/wls/latest/deployments/application

    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy
    echo ">>> Terminating ssh tunnel for WLST"

}

deployApplication_SimpleAuctionWebAppDb() {

    echo ">>> Setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}
    ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}

curl -v -u ${WLSUsername}:${WLSPassword} -H "X-Requested-By:MyClient" -H Accept:application/json -H Content-Type:multipart/form-data -F "model={name:'SimpleAuctionWebAppDb',targets:['${WLSClusterName}']}" -F "deployment=@./SimpleAuctionWebAppDb.war" -X POST http://localhost:${WLSAdminPort}/management/wls/latest/deployments/application

    echo ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    echo ">>> Terminating ssh tunnel for WLST"

}

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    echo ">>> Executing solution for Practice 11-1"

    ./setup.sh
    deployApplication_SimpleAuctionWebAppDb

    echo ">>> The solution for Practice 11-1 has been completed."

fi
