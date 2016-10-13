#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

data={\"password\":\"${opcPassword}\",\"user\":\"/Compute-${identityDomain}/${opcUsername}\"}
contenttype="Content-Type:application/oracle-compute-v3+json"
accepttype=\"Accept:application/oracle-compute-v3+json\"
acceptencoding=\"Accept-Encoding:gzip;q-1.0,identity;q=0.5\"
acceptcharset=\"Accept-Charset:UTF-8\"

echo $data
echo $contenttype

echo curl -i -D - -H $contenttype -X POST -d \'$data\' ${ComputeEndpoint}/authenticate/

curl -i -D - -H $contenttype -X POST -d \'$data\' -k ${ComputeEndpoint}/authenticate/ 

mycurl="curl -i -D - -H $contenttype -X POST -d '$data' -k ${ComputeEndpoint}/authenticate/"

echo $mycurl

response=$($mycurl)

echo $response

#echo wget -O- --header=$contenttype --post-data=\'$data\' ${ComputeEndpoint}/authenticate/

#response=$(wget -O- --header=$contenttype --post-data=\'$data\' ${ComputeEndpoint}/authenticate/)

#echo $response