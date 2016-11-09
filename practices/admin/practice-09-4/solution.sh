#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------
if [  -f psmcli.zip ]; then
    echo psmcli.zip already exists.
    echo removing and re-downloading
    rm psmcli.zip
fi

#
echo Attempting to download psmcli.zip using curl
cmd="curl -k -v -X GET --user ${opcUsername}:${opcPassword} -H X-ID-TENANT-NAME:${identityDomain} https://psm.europe.oraclecloud.com/paas/core/api/v1.1/cli/${identityDomain}/client -o psmcli.zip"
echo $cmd
`$cmd`

#
#
#

