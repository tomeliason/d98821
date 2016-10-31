#!/bin/bash
#
# createDB.sh
#


#
# function createDB iddomain iduser idpassword
#
function createDB() {
	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	if [[ $# -ne 3 ]]; then
		echo "Usage:"
		echo " ${FUNCNAME} iddomain iduser idpassword [dbcsendpoint [storagename]]"
		errorValue="Error: parameter  ${FUNCNAME} "
		echo "$errorValue"
		return 1
	fi

	local iddomain=$1
	local iduser=$2
	local idpassword=$3

	
	local storagename=$StorageName
	local dbcsendpoint=$DBCSEndpoint
	if [[ $# -ge 4 ]]; then
		echo "Using $4 as DBCSendpoint"
		dbcsendpoint=$4
	fi
	if [[ $# -ge 5 ]]; then
		echo "Using $5 as storagename"
		storagename=$5
	fi

	
	echo "Attempting to create database resource for user '$iduser':'$idpassword' in ID '$iddomain'"

	#
	# Short curcuit the script for testing. 
	#	


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
	sshprivatekey=$(<$rsaRoot/id_rsa)

	echo "Attempting to obtain auth token"
	echo "curl -k -X GET -sS -I -H "X-Storage-User:Storage-${iddomain}:${iduser}" -H "X-Storage-Pass:${idpassword}" https://${iddomain}.storage.oraclecloud.com/auth/v1.0"
	authtoken=$(curl -k -X GET -sS -I -H "X-Storage-User:Storage-${iddomain}:${iduser}" -H "X-Storage-Pass:${idpassword}" https://${iddomain}.storage.oraclecloud.com/auth/v1.0 | grep X-Auth-Token | awk {'print $2'})
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

	ech0 "Short circuit exit from createDB"
	return 0;

	echo "Attempting to delete old storage"
	echo "curl -k -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}"
	curl -k -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Curl command could not delete old storage"
		echo "Ignoring, possibly not found"
	else
		echo "Successfully deleted Storage-${iddomain}/${storagename}"
	fi

	echo "Attempting to create storage"
	echo "curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}"
	curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Curl command could not create storage"
		echo "DB Create cannot continue"
		return 1	
	else
		echo "Successfully created Storage-${iddomain}/${storagename}"
	fi

	echo "Attempting to delete old storage Archive"
	echo "curl -k  -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}Archive"
	curl -k -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}Archive
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Curl command could not delete old storage archive"
		echo "Ignoring, possibly not found"
	else
		echo "Successfully deleted archive Storage-${iddomain}/${storagename}Archive"
	fi

	echo "Attempting to create new storage archive"
	curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}Archive
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Curl command could not create storage archive"
		echo "DB Create cannot continue"
		return 1	
	else
		echo "Successfully created archive Storage-${iddomain}/${storagename}Archive"
	fi

	#
	# For some reason via ~/.ssh/.. doesn't work.
	#
	cp $rsaRoot/id_rsa* .
	echo "Pushing RSA keys to host ${iddomain}.storage.oraclecloud.com into localtion Storage-${iddomain}/${storagename}/id_rsa and id_rsa.pub "
	echo "curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}" -T $rsaRoot/id_rsa  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}/id_rsa"
	curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}" -T id_rsa  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}/id_rsa
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Could not push id_rsa private key to storage Storage-${iddomain}/${storagename}/id_rsa"
		echo "DB Create cannot continue"
		rm -f id_rsa*
		return 1	
	else
		echo "Successfully pushed id_rsa private key to storage Storage-${iddomain}/${storagename}/id_rsa"
	fi
	echo "curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  -T $rsaRoot/id_rsa.pub  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}/id_rsa.pub"
	curl -k -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  -T id_rsa.pub  https://${iddomain}.storage.oraclecloud.com/v1/Storage-${iddomain}/${storagename}/id_rsa.pub
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Could not push id_rsa.pub key to storage Storage-${iddomain}/${storagename}/id_rsa.pub"
		echo "DB Create cannot continue"
		rm -f id_rsa*
		return 1	
	else
		echo "Successfully pushed id_rsa.pub private key to storage Storage-${iddomain}/${storagename}/id_rsa.pub"
	fi
	rm -f id_rsa*

	echo "Submitting dbca request"
	echo "https_proxy=https://adc-proxy.oracle.com:80"
	export https_proxy=https://adc-proxy.oracle.com:80
	echo "curl -v --include --request POST --cacert ./cacert.pem --user ${iduser}:${idpassword} --header "X-ID-TENANT-NAME:${iddomain}" --header "Content-Type:application/json" --data "{ \"description\": \"Example service instance\",  \"edition\": \"EE\",  \"level\": \"PAAS\",  \"serviceName\": \"${servicename}\",  \"shape\": \"oc3\",  \"subscriptionType\": \"MONTHLY\",  \"version\": \"12.1.0.2\",  \"vmPublicKeyText\": \"${sshpublickey}\",  \"parameters\": [ { \"type\": \"db\", \"usableStorage\": \"15\", \"adminidpassword\": \"Welcome_1\", \"sid\": \"ORCL\", \"pdbName\": \"PDB1\", \"failoverDatabase\": \"no\", \"backupDestination\": \"BOTH\", \"cloudStorageContainer\": \"Storage-${iddomain}\/${storagename}\", \"cloudStorageUser\": \"${iduser}\", \"cloudStoragePwd\": \"${idpassword}\" } ] }" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${iddomain}"
	curl --include --request POST --cacert ./cacert.pem --user ${iduser}:${idpassword} --header "X-ID-TENANT-NAME:${iddomain}" --header "Content-Type:application/json" --data "{ \"description\": \"Example service instance\",  \"edition\": \"EE\",  \"level\": \"PAAS\",  \"serviceName\": \"${servicename}\",  \"shape\": \"oc3\",  \"subscriptionType\": \"MONTHLY\",  \"version\": \"12.1.0.2\",  \"vmPublicKeyText\": \"${sshpublickey}\",  \"parameters\": [ { \"type\": \"db\", \"usableStorage\": \"15\", \"adminidpassword\": \"Welcome_1\", \"sid\": \"ORCL\", \"pdbName\": \"PDB1\", \"failoverDatabase\": \"no\", \"backupDestination\": \"BOTH\", \"cloudStorageContainer\": \"Storage-${iddomain}\/${storagename}\", \"cloudStorageUser\": \"${iduser}\", \"cloudStoragePwd\": \"${idpassword}\" } ] }" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${iddomain}
	curlStatus=$?
	if [[ "$curlStatus" != 0 ]]; then
		echo "Request to create DB failed"
		return 1	
	else
		echo "Successfully submitted request to create database instance"
	fi
	#unset https_proxy
	#echo "submitted dbcs for creation"

	return 0
}


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#echo "source $CURRENT_DIR/provision.properties"
source $CURRENT_DIR/provision.properties

