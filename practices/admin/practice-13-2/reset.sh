#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# 
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

    echo "setting up ssh tunnelfor REST commands"
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy
    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy
}

function stopSSHTunnel {

    echo "terminating ssh tunnel for WLST"
    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy

}

#
# 
# undeployApplication "application name"
# 
#

function undeployApplication {

    if [[ $# -lt 1 ]]; then
        errorValue="Error: Missing property file.  ${FUNCNAME} "
        echo "$errorValue"
            echo "Usage undeployApplication application"
            return 1
        fi
  

    echo "Attempting to stop and undeploy $1 application"
  

    local whichApplication="$1"
 
    #cmd="
    curl -v --user ${WLSUsername}:${WLSPassword} \
           -H X-Requested-By:MyClient \
           -H Accept:application/json \
	   -H Content-Type:application/json \
           -d "{ target='JCS_cluster' }" \
	   -X POST http://${WLSAdminHost}:${WLSDeployPort}/management/weblogic/latest/domainRuntime/deploymentManager/appDeploymentRuntimes/$whichApplication/getState \
            > testDeploy.out 2>&1

	fourohfour=`grep 404 testDeploy.out`
	#echo fourohfour=$fourohfour
	if [[  -n "$fourohfour" ]]; then
		echo "Application $whichApplication, not found, nothing to do"
		rm -f testDeploy.out
		return 1
	fi
        #echo "Application found, checking state"
	activeApplication=`grep ACTIVE testDeploy.out`
	#echo activeApplication=$activeApplication
	if [[  ! -n "$activeApplication" ]]; then
    	    echo "Application $whichApplication, found but not active, skipping stop"
	else
            echo "Application $whichApplication, found active, stopping before deleting"
 	    curl -v \
	        --user ${WLSUsername}:${WLSPassword} \
                -H X-Requested-By:MyClient \
                -H Accept:application/json \
	        -H Content-Type:application/json \
                -d "{}" \
                -X POST http://${WLSAdminHost}:${WLSDeployPort}/management/weblogic/latest/domainRuntime/deploymentManager/appDeploymentRuntimes/$whichApplication/stop #> /dev/null 2>&1
	fi
	rm -f testDeploy.out

	#
	# Its there and stopped, delete it.
	#
	echo "Deleting $whichApplication"


	#curl -v \
        #    --user ${WLSUsername}:${WLSPassword} \
        #    -H X-Requested-By:MyClient \
        #    -X DELETE http://${WLSAdminHost}:${WLSDeployPort}/management/weblogic/latest/edit/appDeployments/$whichApplication #> /dev/null 2>&1
	#
	# For some reason the newer version of the REST API (12.2.1) does not delete, but the old does.
	cmd="curl -v   --user ${WLSUsername}:${WLSPassword} -H X-Requested-By:MyClient -H Accept:application/json \
            -X DELETE http://${WLSAdminHost}:${WLSDeployPort}/management/wls/latest/deployments/application/id/$whichApplication"
	echo $cmd
	$cmd > /dev/null 2>&1

}



# if this script is called as a main script, execute the function 
if [ ${0##*/} == "reset.sh" ] ; then

    echo ">>> Resetting the practice environment for $(basename $(pwd))"
    startSSHTunnel
	
    undeployApplication ExampleEAR
    undeployApplication ExampleGAR

    stopSSHTunnel  

   echo ">>> $(basename $(pwd)) environment has been reset."

fi
