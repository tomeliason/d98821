#!/bin/bash

identitydomain=ouopc005
username=tom.eliason@oracle.com
password=Welc0me1
servicename=DB
jcsservicename=JCS
storagename=mystorage1
authtoken=none
dbcsendpoint=https://dbcs.emea.oraclecloud.com
jcsendpoint=https://jcs.emea.oraclecloud.com
sshpublickey=none

#rm -rf ~/.ssh/id_rsa
#rm -rf ~/.ssh/id_rsa.pub

#echo -ne '\n\n' | ssh-keygen -b 2048 -t rsa
sshpublickey=$(<~/.ssh/id_rsa.pub)

echo "read ssh key"

curl -i -v -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}

curl -X POST -u ${username}:${password} -d "{ \"serviceName\" : \"${jcsservicename}\", \"level\" : \"PAAS\", \"subscriptionType\" : \"MONTHLY\", \"enableAdminConsole\": \"true\",  \"description\" : \"JCS WLS Domain\", \"provisionOTD\" : \"true\", \"cloudStorageContainer\" : \"Storage-${identitydomain}/JCSBackup\", \"cloudStorageUser\" : \"${username}\", \"cloudStoragePassword\" : \"${password}\", \"createStorageContainerIfMissing\" : \"true\", \"sampleAppDeploymentRequested\" : \"true\", \"parameters\" : [ { \"type\" : \"weblogic\", \"version\" : \"12.2.1\", \"edition\" : \"SUITE\", \"domainMode\" : \"PRODUCTION\", \"domainPartitionCount\" : \"1\", \"domainVolumeSize\" : \"5G\", \"managedServerCount\" : \"2\", \"adminPort\" : \"7001\", \"deploymentChannelPort\" : \"9001\", \"securedAdminPort\" : \"7002\", \"contentPort\" : \"8001\", \"securedContentPort\" : \"8002\", \"domainName\" : \"JCS\", \"clusterName\" : \"JCS_Cluster\", \"adminUserName\" : \"weblogic\", \"adminPassword\" : \"Welcome_1\", \"nodeManagerPort\" : \"5556\", \"nodeManagerUserName\" : \"nodeMangerAdmin\", \"nodeManagerPassword\" : \"Welcome_1\", \"dbServiceName\" : \"${servicename}\", \"dbaName\" : \"SYS\", \"dbaPassword\" : \"Welcome_1\", \"shape\" : \"oc3\", \"domainVolumeSize\" : \"10G\", \"backupVolumeSize\" : \"50G\", \"VMsPublicKey\" : \"${sshpublickey}\" }, { \"type\" : \"OTD\", \"adminUserName\" : \"otdAdmin\", \"adminPassword\" : \"Welcome_1\", \"listenerPortsEnabled\" : \"true\", \"listenerPort\" : \"8080\", \"listenerType\" : \"http\", \"securedListenerPort\" : \"8081\", \"loadBalancingPolicy\" : \"least_connection_count\", \"adminPort\" : \"8989\", \"shape\" : \"oc3\", \"VMsPublicKey\" : \"${sshpublickey}\" }, { \"type\" : \"datagrid\", \"scalingUnitCount\" : \"1\", \"clusterName\" : \"JCS_COH_Cluster\", \"scalingUnit\" : {  \"shape\" : \"oc3\", \"vmCount\" : \"1\", \"heapSize\" : \"2G\", \"jvmCount\" : \"2\" } } ] } " -H "Content-Type:application/vnd.com.oracle.oracloud.provisioning.Service+json" -H "X-ID-TENANT-NAME:${identitydomain}" ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} | gunzip

echo "submitted jcs for creation"
