#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "source $CURRENT_DIR/iduser.properties"

#
#  checkDBExists iddomain iduser ididpassword
#  Return 0 - Exists and running
#  Return 1 - Exists but not running
#  Return 2 - Not found
#  Any other - Error of some sort
#
function checkDBExists() {

	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	if [[ $# -ne 3 ]]; then
		echo "Usage:"
		echo " ${FUNCNAME} iddomain iduser ididpassword [dbcsendpoint [storagename]]"
		errorValue="Error: parameter  ${FUNCNAME} "
		echo "$errorValue"
		return 3
	fi

	local iddomain=$1
	local iduser=$2
	local idpassword=$3
	local dbservicename=$DBCSServiceName # DB

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

	#
	# We should be checking if the cert exists, and if not copying it from /practices/common
	# if it exists we should be checking its the same one
	#
	cp /practices/common/cacert.pem .

	echo "Testing whether ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${iddomain}/${dbservicename} exists and is running"
	echo "curl -s --include --request GET --cacert cacert.pem --user ${iduser}:${idpassword} --header "X-ID-TENANT-NAME:${iddomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${iddomain}/${dbservicename}"
	curlResponse=$(curl -s --include --request GET --cacert cacert.pem --user ${iduser}:${idpassword} --header "X-ID-TENANT-NAME:${iddomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${iddomain}/${dbservicename})
	#hack
	curl -s --include --request GET --cacert cacert.pem --user ${iduser}:${idpassword} --header "X-ID-TENANT-NAME:${iddomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${iddomain}/${dbservicename}> fourohfour.out 2>&1
	fourohfour=`grep 404 fourohfour.out`
	fourohone=`grep 401 fourohfour.out`
	#echo fourohfour=$fourohfour
	rm -f fourohfour.out
	if [[  -n "$fourohfour" ]]; then
		echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} does not appear to exist ($fourohfour)"
		return 2
	fi
	echo "Fourohone = $fourohone"
	if [[  -n "$fourohone" ]]; then
		echo "User $iduser:idpassword does not appear to be authorized to read DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain}"
		return 3
	fi
	echo $curlResponse |cut -d',' -f 4 |cut -d':' -f 2  |tr -d '\"' |tr -d '[[:space:]]' #| tr -d ',\"'
	echo curlResponse=$curlResponse
	#status=`echo $curlResponse | cut -d':' -f 2 | tr -d '[[:space:]]' #| tr -d ',\"'`
	status=`echo $curlResponse ` # |cut -d',' -f 4 |cut -d':' -f 2  |tr -d '\"' |tr -d '[[:space:]]' #| tr -d ',\"'`
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} status = ${status}"
	if [[ "$status" = "Running" ]] ; then
		echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} exists and is running."
		return 0
	else
		echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${iddomain} exists but is not running. Status=${status}."
		return 1
	fi

	return 0
}
