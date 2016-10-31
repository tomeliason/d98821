#!/bin/bash
#
# jcs.sh
#


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/userlist.properties

#
# function createDB iddomain iduser ididpassword
# Returns 0 on success
# Returns 1 missing SSH keys
# Returns 2 Missing JCS Endpoint
# Returns 3 Missing DB
# 
function createJCS() {
	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	if [[ $# -ne 3 ]]; then
		echo "Usage:"
		echo " ${FUNCNAME} iddomain iduser ididpassword [jcsendpoint ]"
		errorValue="Error: parameter  ${FUNCNAME} "
		echo "$errorValue"
		return 1
	fi

	local iddomain=$1
	local iduser=$2
	local ididpassword=$3
	local jcsendpoint=$4

	local dbcsendpoint=$JCSEndpoint
	if [[ $# -ge 4 ]]; then
		echo "Using $4 as JCS Endpoint"
		jcsendpoint=$4
	fi


	rsaRoot=`realpath ~`/.ssh
	if [[ ! -f $rsaRoot/id_rsa ]]; then
		echo "Error $rsaRoot/id_rsa not found!"
		return 1
	else
		echo "Using RSA private key $rsaRoot/id_rsa"
		#cat $rsaRoot/id_rsa
	fi
	if [[ ! -f $rsaRoot/id_rsa.pub ]]; then
		echo "Error $rsaRoot/id_rsa.pub not found!"
		return 1
	else
		echo "Using RSA public key $rsaRoot/id_rsa.pub"
		#cat $rsaRoot/id_rsa.pub
	fi

	sshpublickey=$(<~/.ssh/id_rsa.pub)


	echo "Attempting to confirm jcs end point exists"
	#echo "curl -k -i -v -X GET -u ${iduser}:${idpassword} -H "X-ID-TENANT-NAME:${iddomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain}"
	curl -k -i -X GET -u ${iduser}:${idpassword} -H "X-ID-TENANT-NAME:${iddomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} >> /dev/null
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Unable to access JCS end point ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} with credentials ${iduser}:idpassword."
		echo "JCS create cannot continue"
		return 2	
	else
		echo "JCS end point ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} aailable continuing with create."
	fi


	echo "Attempting to determine if DB End point exists and DB is running"
	curlBaseURL="${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${iddomain}/${dbservicename}"
	#echo curl -i -X GET --cacert ./cacert.pem --user ${iduser}:${idpassword} --header "X-ID-TENANT-NAME:${iddomain}"  $curlBaseURL
	curl -i -X GET --cacert ./cacert.pem --user ${iduser}:${idpassword} --header "X-ID-TENANT-NAME:${iddomain}"  $curlBaseURL > db.out 2>&1
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Unable to access DB  end point at $curlBaseURL ${iduser}:idpassword."
		echo "JCS create cannot continue"
		return 3	
	else
		echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} available continuing with create."
		fi
	#
	# Now check its status is running
	#
	cat db.out | grep status | awk {'print $2'}
	if [[ "`grep status db.out | awk {'print $2'} | tr -d '[[:space:]]' | tr -d ',\"'`" = "Running" ]] ; then
		echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} exists and is running."
	else
		echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} exists but is not running."
		echo "JCS create cannot continue"
		rm -f db.out
		return 1
	fi
	rm -r db.out



	echo "Attempting to submit JCS create request"

	curl -k -i -X POST -u ${iduser}:${idpassword} -d "{ \"serviceName\" : \"${jcsservicename}\", \"level\" : \"PAAS\", \"subscriptionType\" : \"MONTHLY\", \"enableAdminConsole\": \"true\",  \"description\" : \"JCS WLS Domain\", \"provisionOTD\" : \"true\", \"cloudStorageContainer\" : \"Storage-${iddomain}/JCSBackup\", \"cloudStorageUser\" : \"${iduser}\", \"cloudStorageidpassword\" : \"${idpassword}\", \"createStorageContainerIfMissing\" : \"true\", \"sampleAppDeploymentRequested\" : \"true\", \"parameters\" : [ { \"type\" : \"weblogic\", \"version\" : \"12.2.1\", \"edition\" : \"SUITE\", \"domainMode\" : \"PRODUCTION\", \"domainPartitionCount\" : \"1\", \"domainVolumeSize\" : \"5G\", \"managedServerCount\" : \"2\", \"adminPort\" : \"7001\", \"deploymentChannelPort\" : \"9001\", \"securedAdminPort\" : \"7002\", \"contentPort\" : \"8001\", \"securedContentPort\" : \"8002\", \"domainName\" : \"JCS\", \"clusterName\" : \"JCS_Cluster\", \"adminiduser\" : \"weblogic\", \"adminidpassword\" : \"Welcome_1\", \"nodeManagerPort\" : \"5556\", \"nodeManageriduser\" : \"nodeMangerAdmin\", \"nodeManageridpassword\" : \"Welcome_1\", \"dbServiceName\" : \"${servicename}\", \"dbaName\" : \"SYS\", \"dbaidpassword\" : \"Welcome_1\", \"shape\" : \"oc3\", \"domainVolumeSize\" : \"10G\", \"backupVolumeSize\" : \"50G\", \"VMsPublicKey\" : \"${sshpublickey}\" }, { \"type\" : \"OTD\", \"adminiduser\" : \"otdAdmin\", \"adminidpassword\" : \"Welcome_1\", \"listenerPortsEnabled\" : \"true\", \"listenerPort\" : \"8080\", \"listenerType\" : \"http\", \"securedListenerPort\" : \"8081\", \"loadBalancingPolicy\" : \"least_connection_count\", \"adminPort\" : \"8989\", \"shape\" : \"oc3\", \"VMsPublicKey\" : \"${sshpublickey}\" }, { \"type\" : \"datagrid\", \"scalingUnitCount\" : \"1\", \"clusterName\" : \"JCS_COH_Cluster\", \"scalingUnit\" : {  \"shape\" : \"oc3\", \"vmCount\" : \"1\", \"heapSize\" : \"2G\", \"jvmCount\" : \"2\" } } ] } " -H "Content-Type:application/vnd.com.oracle.oracloud.provisioning.Service+json" -H "X-ID-TENANT-NAME:${iddomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain}# | gunzip
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "JCS Submit request failed."
		echo "JCS create cannot continue"
		return 1	
	fi
	echo "JCS submit request completed"

	return 0
}
