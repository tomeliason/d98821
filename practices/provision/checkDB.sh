#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "source $CURRENT_DIR/provision.properties"
source $CURRENT_DIR/provision.properties

echo "Testing whether ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${dbservicename} exists and is running"
echo "curl -s --include --request GET --cacert cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${dbservicename}"
curlResponse=$(curl -s --include --request GET --cacert cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${dbservicename})
#hack
curl -s --include --request GET --cacert cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${dbservicename}> fourohfour.out 2>&1
fourohfour=`grep 404 fourohfour.out`
#echo fourohfour=$fourohfour
rm -f fourohfour.out
if [[  -n "$fourohfour" ]]; then
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} does not appear to exist ($fourohfour)"
	return 1
fi
echo $curlResponse |cut -d',' -f 4 |cut -d':' -f 2  |tr -d '\"' |tr -d '[[:space:]]' #| tr -d ',\"'
echo curlResponse=$curlResponse
#status=`echo $curlResponse | cut -d':' -f 2 | tr -d '[[:space:]]' #| tr -d ',\"'`
status=`echo $curlResponse |cut -d',' -f 4 |cut -d':' -f 2  |tr -d '\"' |tr -d '[[:space:]]' #| tr -d ',\"'`
#echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} status = ${status}"
if [[ "$status" = "Running" ]] ; then
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} exists and is running."
else
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} exists but is not running. Status=${status}."
fi
#rm -r db.out
