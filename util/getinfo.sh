#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

. ../common/common.properties
. ../common/common.sh


echo curl -i -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}"  https://${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}/${jcsservicename}

curl -i -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}"  ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}/${jcsservicename}

echo curl --include --request GET --cacert ~/cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${servicename}

curl --include --request GET --cacert ~/cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${servicename}

echo ""

#curl -s -i -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}"  ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}/${jcsservicename} | jsonValue3 wls_admin_url

#curl -s -i -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}"  ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}/${jcsservicename} | jsonValue3 otd_admin_url

#curl -s --include --request GET --cacert ~/cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${servicename} |  jsonValue connect_descriptor_with_public_ip


response=$(curl -s -i -X GET -u ${username}:${password} -H "X-ID-TENANT-NAME:${identitydomain}"  ${jcsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}/${jcsservicename})

wls_admin_url=`echo $response | sed -e 's/^.*"wls_admin_url"[ ]*:[ ]*"//' -e 's/".*//'`
otd_admin_url=`echo $response | sed -e 's/^.*"otd_admin_url"[ ]*:[ ]*"//' -e 's/".*//'`
wls_ip=`echo $wls_admin_url | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`
otd_ip=`echo $otd_admin_url | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`

response=$(curl -s --include --request GET --cacert ~/cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}/${servicename})

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