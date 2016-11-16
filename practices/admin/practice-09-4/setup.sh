#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# setup script


# if this script is called as a main script, execute the function 
if [ ${0##*/} == "setup.sh" ] ; then

        echo ">>> Setting up the practice environment for $(basename $(pwd))"


	#echo ">>> ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy"
        #ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSDeployPort}:${JCSHost}:${WLSDeployPort} opc@remotehost-proxy

	#source $WL_HOME/server/bin/setWLSEnv.sh

	PYTHONPATH=/opt/python/bin
	#export PATH=`echo $PATH | sed "s=:$PYTHONPATH==g"`:$PYTHONPATH

        echo ">>> "      
        echo ">>> $(basename $(pwd)) environment has been setup."
fi
