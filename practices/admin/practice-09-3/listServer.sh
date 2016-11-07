#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------
echo "curl -v --user ${WLSUsername}:${WLSPassword} -H X-Requested-By:MyClient -H Accept:application/json -X GET http://${WLSAdminHost}:${WLSDeployPort}/management/weblogic/latest/domainRuntime/serverLifeCycleRuntimes?links=none"

curl -v --user ${WLSUsername}:${WLSPassword} \
     -H X-Requested-By:MyClient \
     -H Accept:application/json \
     -X GET http://${WLSAdminHost}:${WLSDeployPort}/management/weblogic/latest/domainRuntime/serverLifeCycleRuntimes?links=none"
