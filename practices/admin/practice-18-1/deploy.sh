# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------
# copy the application to the domain's apps directory
cp timeoff.war /u01/domains/part1/wlsadmin/apps/timeoff.war
# set up the environment for WLST
source /u01/app/fmw/wlserver/server/bin/setWLSEnv.sh
# run the script to deploy the web application that uses role-based security
java weblogic.WLST deploy_app.py
