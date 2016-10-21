#!/bin/bash
#
# jcs.sh
#


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/provision.properties


rsaRoot=`realpath ~`/.ssh
echo $rsaRoot
if [[ ! -f $rsaRoot/id_rsa ]]; then
	echo "Error $rsaRoot/id_rsa not found, perhaps you should run ssh-keygen?"
	return 1
else
	echo "Using RSA private key $rsaRoot/id_rsa"
	#cat $rsaRoot/id_rsa
fi
if [[ ! -f $rsaRoot/id_rsa.pub ]]; then
	echo "Error $rsaRoot/id_rsa.pub not found, perhaps you should run ssh-keygen?"
	return 1
else
	echo "Using RSA public key $rsaRoot/id_rsa.pub"
	#cat $rsaRoot/id_rsa.pub
fi

sshpublickey=$(<~/.ssh/id_rsa.pub)


echo "Attempting to confirm jcs end point exists"
#echo "curl -k -i -v -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}"
curl -k -i -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} >> /dev/null
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Unable to access JCS end point ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} with credentials ${username}:password."
	echo "JCS create cannot continue"
	return 1	
else
	echo "JCS end point ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} aailable continuing with create."
fi


echo "Attempting to determine if DB End point exists and DB is running"
curlBaseURL="${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identityDomain}/${dbservicename}"
#echo curl -i -X GET --cacert ./cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}"  $curlBaseURL
curl -i -X GET --cacert ./cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}"  $curlBaseURL > db.out 2>&1
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Unable to access DB  end point at $curlBaseURL ${username}:password."
	echo "JCS create cannot continue"
	return 1	
else
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} available continuing with create."
fi
#
# Now check its status is running
#
cat db.out | grep status | awk {'print $2'}
if [[ "`grep status db.out | awk {'print $2'} | tr -d '[[:space:]]' | tr -d ',\"'`" = "Running" ]] ; then
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} exists and is running."
else
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} exists but is not running."
	echo "JCS create cannot continue"
	rm -f db.out
	return 1
fi
rm -r db.out



echo "Attempting to submit JCS create request"

curl -k -i -X POST -u ${username}:${password} -d "{ \"serviceName\" : \"${jcsservicename}\", \"level\" : \"PAAS\", \"subscriptionType\" : \"MONTHLY\", \"enableAdminConsole\": \"true\",  \"description\" : \"JCS WLS Domain\", \"provisionOTD\" : \"true\", \"cloudStorageContainer\" : \"Storage-${identitydomain}/JCSBackup\", \"cloudStorageUser\" : \"${username}\", \"cloudStoragePassword\" : \"${password}\", \"createStorageContainerIfMissing\" : \"true\", \"sampleAppDeploymentRequested\" : \"true\", \"parameters\" : [ { \"type\" : \"weblogic\", \"version\" : \"12.2.1\", \"edition\" : \"SUITE\", \"domainMode\" : \"PRODUCTION\", \"domainPartitionCount\" : \"1\", \"domainVolumeSize\" : \"5G\", \"managedServerCount\" : \"2\", \"adminPort\" : \"7001\", \"deploymentChannelPort\" : \"9001\", \"securedAdminPort\" : \"7002\", \"contentPort\" : \"8001\", \"securedContentPort\" : \"8002\", \"domainName\" : \"JCS\", \"clusterName\" : \"JCS_Cluster\", \"adminUserName\" : \"weblogic\", \"adminPassword\" : \"Welcome_1\", \"nodeManagerPort\" : \"5556\", \"nodeManagerUserName\" : \"nodeMangerAdmin\", \"nodeManagerPassword\" : \"Welcome_1\", \"dbServiceName\" : \"${servicename}\", \"dbaName\" : \"SYS\", \"dbaPassword\" : \"Welcome_1\", \"shape\" : \"oc3\", \"domainVolumeSize\" : \"10G\", \"backupVolumeSize\" : \"50G\", \"VMsPublicKey\" : \"${sshpublickey}\" }, { \"type\" : \"OTD\", \"adminUserName\" : \"otdAdmin\", \"adminPassword\" : \"Welcome_1\", \"listenerPortsEnabled\" : \"true\", \"listenerPort\" : \"8080\", \"listenerType\" : \"http\", \"securedListenerPort\" : \"8081\", \"loadBalancingPolicy\" : \"least_connection_count\", \"adminPort\" : \"8989\", \"shape\" : \"oc3\", \"VMsPublicKey\" : \"${sshpublickey}\" }, { \"type\" : \"datagrid\", \"scalingUnitCount\" : \"1\", \"clusterName\" : \"JCS_COH_Cluster\", \"scalingUnit\" : {  \"shape\" : \"oc3\", \"vmCount\" : \"1\", \"heapSize\" : \"2G\", \"jvmCount\" : \"2\" } } ] } " -H "Content-Type:application/vnd.com.oracle.oracloud.provisioning.Service+json" -H "X-ID-TENANT-NAME:${identitydomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}# | gunzip
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "JCS Submit request failed."
	echo "JCS create cannot continue"
	return 1	
fi
echo "JCS submit request completed"

return 0