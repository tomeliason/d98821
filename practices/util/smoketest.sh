# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# create data source to DBCS
# deploy auction app to JCS using data source
# attempt to perform a GET that accesses the auction app and uses the database

# function to create a JDBC Data Source named datasource1 using WLST
createJDBCDataSource_datasource1() {
    
    echo "setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    source $WL_HOME/server/bin/setWLSEnv.sh
    
    java weblogic.WLST create_data_source.py

    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy
    echo "terminating ssh tunnel for WLST"

}

# function to deploy the contacts application to weblogic server
# environment variables:
#   - JCSHost        - IP Address of the Admin Server
#   - WLSDeployPort  - Port of the Admin Server - Administration Port
#   - WLSUsername    - Admin User
#   - WLSPassword    - Admin Password
#   - WLSClusterName - Target Cluster

deployApplication_simpleAuctionWebAppDb() {

curl -v -k -u ${WLSUsername}:${WLSPassword} -H "X-Requested-By:MyClient" -H Accept:application/json -H Content-Type:multipart/form-data -F "model={name:'SimpleAuctionWebAppDb',targets:['${WLSClusterName}']}" -F "deployment=@./SimpleAuctionWebAppDb.war" -X POST https://${JCSHost}:${WLSSecureDeployPort}/management/wls/latest/deployments/application

}

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "smoketest.sh" ] ; then

    createJDBCDataSource_datasource1
    deployApplication_simpleAuctionWebAppDb

fi
