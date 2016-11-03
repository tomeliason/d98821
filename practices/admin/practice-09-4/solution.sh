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
function startSSHTunnel {

    echo "setting up ssh tunnel for REST"
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy
    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy
}

function stopSSHTunnel {

    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy
    echo "terminating ssh tunnel for WLST"

}

listKnownWLSServers() {


cmd="curl -v --user ${WLSUsername}:${WLSPassword} -H X-Requested-By:MyClient -H Accept:application/json -X GET http://${WLSAdminHost}:${WLSDeployPort}/management/weblogic/latest/domainRuntime/serverLifeCycleRuntimes?links=none"
echo $cmd
$cmd| grep name | sort | grep -i _server

# echo $rawResult | grep name | grep JCS
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
    serverName=$1
    echo "Attempting to stop server '$serverName'"
    cmd="curl -v --user ${WLSUsername}:${WLSPassword} -H X-Requested-By:MyClient -H Accept:application/json -X POST http://${WLSAdminHost}:${WLSDeployPort}/management/wls/latest/servers/id/${serverName}/shutdown"
    echo $cmd
    $cmd
    return $?
}

#
# Start a given named server
# Returns the status of the curl request
#
function startNamedServer {
    serverName=$1
    echo "Attempting to [re]start server '$serverName'"
    cmd="curl -v --user ${WLSUsername}:${WLSPassword} -H X-Requested-By:MyClient -H Accept:application/json -X POST http://${WLSAdminHost}:${WLSDeployPort}/management/wls/latest/servers/id/${serverName}/start"
    echo $cmd
    $cmd
    return $?
}


# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    ./setup.sh
  
    startSSHTunnel
    listKnownWLSServers
    getServerName
    
    stopNamedServer $serverName
    read -p "Please access one of the WLS or FMW Consoles to confirm server $serverName is stopped, hit enter when confirmed" answer
    startNamedServer $serverName
    stopSSHTunnel  

fi
