#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

echo curl -i -X GET -u ${opcUsername}:${opcPassword} -H "X-ID-TENANT-NAME:${identityDomain}"  ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName}

curl -i -X GET -u ${opcUsername}:${opcPassword} -H "X-ID-TENANT-NAME:${identityDomain}"  ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName}

echo curl --include --request GET --cacert ~/cacert.pem --user ${opcUsername}:${opcPassword} --header "X-ID-TENANT-NAME:${identityDomain}" ${DBCSEndpoint}/paas/service/dbcs/api/v1.1/instances/${identityDomain}/${DBCSServiceName}

curl --include --request GET --cacert ~/cacert.pem --user ${opcUsername}:${opcPassword} --header "X-ID-TENANT-NAME:${identityDomain}" ${DBCSEndpoint}/paas/service/dbcs/api/v1.1/instances/${identityDomain}/${DBCSServiceName}

echo ""


response=$(curl -s -i -X GET -u ${opcUsername}:${opcPassword} -H "X-ID-TENANT-NAME:${identityDomain}"  ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName})

wls_admin_url=`echo $response | sed -e 's/^.*"wls_admin_url"[ ]*:[ ]*"//' -e 's/".*//'`
otd_admin_url=`echo $response | sed -e 's/^.*"otd_admin_url"[ ]*:[ ]*"//' -e 's/".*//'`
wls_ip=`echo $wls_admin_url | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`
otd_ip=`echo $otd_admin_url | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`

response=$(curl -s --include --request GET --cacert ~/cacert.pem --user ${opcUsername}:${opcPassword} --header "X-ID-TENANT-NAME:${identityDomain}" ${DBCSEndpoint}/paas/service/dbcs/api/v1.1/instances/${identityDomain}/${DBCSServiceName})

db_address=`echo $response | sed -e 's/^.*"em_url"[ ]*:[ ]*"//' -e 's/".*//'`
db_connect=`echo $response | sed -e 's/^.*"connect_descriptor_with_public_ip"[ ]*:[ ]*"//' -e 's/".*//'`
db_ip=`echo $db_address | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`

echo WLS ADMIN URL: ${wls_admin_url}
echo OTD ADMIN URL: ${otd_admin_url}
echo DB ADDRESS: ${db_address}
echo DB CONNECT: ${db_connect}
echo WLS ADMIN IP: ${wls_ip}
echo OTD IP: ${otd_ip}
echo DB IP: ${db_ip}
