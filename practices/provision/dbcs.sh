#!/bin/bash
#
# dbcs.sh
#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "source $CURRENT_DIR/provision.properties"
source $CURRENT_DIR/provision.properties

#echo "Cleaning up old rsa keys"
#rm -rf ~/.ssh/id_rsa
#rm -rf ~/.ssh/id_rsa.pub

#echo "Generating new RSA keys"
#echo -ne '\n\n\n' | ssh-keygen -b 2048 -t rsa

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


sshpublickey=$(<$rsaRoot/id_rsa.pub)
#echo sshpublickey=$sshpublickey
sshprivatekey=$(<$rsaRoot/id_rsa)
#echo sshprivatekey=$sshprivatekey
#return 0

echo "Attempting to obtain auth token"
echo "curl -k -X GET -sS -I -H "X-Storage-User:Storage-${identitydomain}:${username}" -H "X-Storage-Pass:${password}" https://${identitydomain}.storage.oraclecloud.com/auth/v1.0"
authtoken=$(curl -k -X GET -sS -I -H "X-Storage-User:Storage-${identitydomain}:${username}" -H "X-Storage-Pass:${password}" https://${identitydomain}.storage.oraclecloud.com/auth/v1.0 | grep X-Auth-Token | awk {'print $2'})
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Curl command to get auth token failed"
	echo "DB Create cannot continue"
	return 1	
else
	echo "Using authtoken='$authtoken'"
fi
if [[ -z "${authtoken}" ]] ; then
	echo "Curl returned success, but did not return an authtoken".
	echo "DB Create cannot continue"
	return 1
fi
echo "obtained authorization token"
#return 0

echo "Attempting to delete old storage"
echo "curl -k -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}"
curl -k -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Curl command could not delete old storage"
	echo "Ignoring, possibly not found"
else
	echo "Successfully deleted Storage-${identitydomain}/${storagename}"
fi

echo "Attempting to create storage"
echo "curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}"
curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Curl command could not create storage"
	echo "DB Create cannot continue"
	return 1	
else
	echo "Successfully created Storage-${identitydomain}/${storagename}"
fi

echo "Attempting to delete old storage Archive"
echo "curl -k  -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}Archive"
curl -k -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}Archive
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Curl command could not delete old storage archive"
	echo "Ignoring, possibly not found"
else
	echo "Successfully deleted archive Storage-${identitydomain}/${storagename}Archive"
fi

echo "Attempting to create new storage archive"
curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}Archive
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Curl command could not create storage archive"
	echo "DB Create cannot continue"
	return 1	
else
	echo "Successfully created archive Storage-${identitydomain}/${storagename}Archive"
fi

#
# For some reason via ~/.ssh/.. doesn't work.
#
cp $rsaRoot/id_rsa* .
echo "Pushing RSA keys to host ${identitydomain}.storage.oraclecloud.com into localtion Storage-${identitydomain}/${storagename}/id_rsa and id_rsa.pub "
echo "curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}" -T $rsaRoot/id_rsa  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}/id_rsa"
curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}" -T id_rsa  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}/id_rsa
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Could not push id_rsa private key to storage Storage-${identitydomain}/${storagename}/id_rsa"
	echo "DB Create cannot continue"
	rm -f id_rsa*
	return 1	
else
	echo "Successfully pushed id_rsa private key to storage Storage-${identitydomain}/${storagename}/id_rsa"
fi
echo "curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  -T $rsaRoot/id_rsa.pub  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}/id_rsa.pub"
curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  -T id_rsa.pub  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}/id_rsa.pub
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Could not push id_rsa.pub key to storage Storage-${identitydomain}/${storagename}/id_rsa.pub"
	echo "DB Create cannot continue"
	rm -f id_rsa*
	return 1	
else
	echo "Successfully pushed id_rsa.pub private key to storage Storage-${identitydomain}/${storagename}/id_rsa.pub"
fi
rm -f id_rsa*

echo "Submitting dbca request"
echo "https_proxy=https://adc-proxy.oracle.com:80"
export https_proxy=https://adc-proxy.oracle.com:80
echo "curl -v --include --request POST --cacert ./cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" --header "Content-Type:application/json" --data "{ \"description\": \"Example service instance\",  \"edition\": \"EE\",  \"level\": \"PAAS\",  \"serviceName\": \"${servicename}\",  \"shape\": \"oc3\",  \"subscriptionType\": \"MONTHLY\",  \"version\": \"12.1.0.2\",  \"vmPublicKeyText\": \"${sshpublickey}\",  \"parameters\": [ { \"type\": \"db\", \"usableStorage\": \"15\", \"adminPassword\": \"Welcome_1\", \"sid\": \"ORCL\", \"pdbName\": \"PDB1\", \"failoverDatabase\": \"no\", \"backupDestination\": \"BOTH\", \"cloudStorageContainer\": \"Storage-${identitydomain}\/${storagename}\", \"cloudStorageUser\": \"${username}\", \"cloudStoragePwd\": \"${password}\" } ] }" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}"
curl --include --request POST --cacert ./cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" --header "Content-Type:application/json" --data "{ \"description\": \"Example service instance\",  \"edition\": \"EE\",  \"level\": \"PAAS\",  \"serviceName\": \"${servicename}\",  \"shape\": \"oc3\",  \"subscriptionType\": \"MONTHLY\",  \"version\": \"12.1.0.2\",  \"vmPublicKeyText\": \"${sshpublickey}\",  \"parameters\": [ { \"type\": \"db\", \"usableStorage\": \"15\", \"adminPassword\": \"Welcome_1\", \"sid\": \"ORCL\", \"pdbName\": \"PDB1\", \"failoverDatabase\": \"no\", \"backupDestination\": \"BOTH\", \"cloudStorageContainer\": \"Storage-${identitydomain}\/${storagename}\", \"cloudStorageUser\": \"${username}\", \"cloudStoragePwd\": \"${password}\" } ] }" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}
curlStatus=$?
if [[ "$curlStatus" != 0 ]]; then
	echo "Request to create DB failed"
	return 1	
else
	echo "Successfully submitted request to create database instance"
fi
#unset https_proxy
#echo "submitted dbcs for creation"
