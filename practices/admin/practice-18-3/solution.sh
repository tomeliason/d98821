#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------

# environment variables:
#   - JCSHost        - IP Address of the Admin Server
#   - WLSAdminHost   - 
#   - WLSDeployPort  - Port of the Admin Server - Administration Port
#   - WLSUsername    - Admin User
#   - WLSPassword    - Admin Password
#   - WLSClusterName - Target Cluster

practicedir=/practices/admin/practice-18-3

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "solution.sh" ] ; then

    echo ">>> Executing solution for Practice 18-3"

    createPartition
    deployShoppingCart
        
    echo ">>> The solution for Practice 18-3 has been completed."

fi

