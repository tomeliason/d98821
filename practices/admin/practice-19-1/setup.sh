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
    echo ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}
    ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}

    source $WL_HOME/server/bin/setWLSEnv.sh
    
    export DBCSURL="jdbc:oracle:thin:@DB:1521/PDB1.${identityDomain}.oraclecloud.internal"
    export DBCSAuctionUsername=ORACLE
    export DBCSAuctionPassword=ORACLE
        
    java weblogic.WLST create_data_source.py

    echo ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    echo ">>> Terminating ssh tunnel for WLST"

}

deployApplication_SimpleAuctionWebAppDbSec() {

    echo ">>> Setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}
    #ssh -i ~/.ssh/id_rsa -M -S jcs-ctrl-socket -fnNTL ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@${JCSHost}

#curl -v -u ${WLSUsername}:${WLSPassword} -k -H "X-Requested-By:MyClient" -H Accept:application/json -H Content-Type:multipart/form-data -F "model={name:'SimpleAuctionWebAppDbSec',securityDDModel:'CustomRolesAndPolicies',targets:[{identity: ['clusters','${WLSClusterName}']} ]}" -F "sourcePath=@./SimpleAuctionWebAppDbSec.war" -X POST https://${JCSHost}:7002/management/weblogic/latest/edit/appDeployments

    echo ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    #ssh -S jcs-ctrl-socket -O "exit" opc@${JCSHost}
    echo ">>> Terminating ssh tunnel for WLST"

}

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "setup.sh" ] ; then

        echo ">>> Setting up the practice environment for Practice 19-1"

        echo ">>> Creating the data source"
        
        createJDBCDataSource_AuctionDB
        
        echo ">>> The data source has been created."
        
        echo ">>> Deploying the application"
        
        deployApplication_SimpleAuctionWebAppDbSec
        
        echo ">>> The application has been deployed."

        echo ">>> Practice 19-1 environment has been setup."

fi
