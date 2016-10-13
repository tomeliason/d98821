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
contenttype=\"Content-Type:text/plain;charset=utf-8\"

echo $data
echo $contenttype

echo curl -v -H $contenttype X POST --data \'$data\' ${ComputeEndpoint}/authenticate/

curl -v -H $contenttype -X POST --data \'$data\' -k ${ComputeEndpoint}/authenticate/ > temp.txt

response=$(curl -v -H $contenttype X POST --data \'$data\' -k ${ComputeEndpoint}/authenticate/)

echo $response

#echo wget -O- --header=$contenttype --post-data=\'$data\' ${ComputeEndpoint}/authenticate/

#response=$(wget -O- --header=$contenttype --post-data=\'$data\' ${ComputeEndpoint}/authenticate/)

#echo $response