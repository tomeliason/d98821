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
#   - WLSAdmin 
function startSSHTunnel {

    echo "setting up ssh tunnel for WLST "
    echo "ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${WLSAdminHost}:${WLSAdminPort} opc@remotehost-proxy"
    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${WLSAdminHost}:${WLSAdminPort} opc@remotehost-proxy
}

function stopSSHTunnel {

    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy
    echo "terminating ssh tunnel for WLST"

}

listKnownWLSServers() {

echo
echo "Listing all known servers"
$MW_HOME/oracle_common/common/bin/wlst.sh $(pwd)/listServers.py 
echo

}

function getServerName {
    read -p "From the list of servers enter a server name:" serverName
    while true ; do
        read -p "You entered '${serverName}' is this correct? Y/n [Y]" answer
	# default is yes
	if [[ -z "$answer" ]]; then
		answer="Y"
	fi
	case $answer in
	   [yY]* )
		echo "Continuing with server '$serverName"
		break ;;	
	   [nN]* ) 
		read -p "From the list of servers enter a server name:" serverName
		continue;;
	   * )  echo "unknown value '$answer'"; 
		continue ;;
	esac
done


}


#
# Stop a given named server
# Returns the status of the curl requiest
function stopNamedServer {
    local serverName=$1
    echo "Stopping $serveraName"
    java weblogic.WLST $(pwd)/stopServer.py $serverName
}

#
# Start a given named server
# Returns the status of the curl request
#
function startNamedServer {
    local serverName=$1
    echo "Starting $serveraName"
    java weblogic.WLST $(pwd)/startServer.py $serverName
}


# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    ./setup.sh
  
    startSSHTunnel
    source $WL_HOME/server/bin/setWLSEnv.sh
    listKnownWLSServers
    getServerName
    
    stopNamedServer $serverName
    read -p "Please access one of the WLS or FMW Consoles to confirm server $serverName is stopped, hit enter when confirmed" answer
    startNamedServer $serverName
    stopSSHTunnel  

fi
