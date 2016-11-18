# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------
CURRENT_PRACTICE=/practices/part1/practice16-01
echo ">>>Stopping the LDAP Server (in case it is running)"
LDAP_HOME=/u01/app/ldap
# first stop the LDAP server (in case it has been started)
$LDAP_HOME/bin/stop-ds
# import the two users and the group into the external LDAP system
# (they were exported by using the export-ldif executable:
# ./export-ldif -l solution.ldif -n userRoot -h host02.example.com -p 7879 -w Welcome1
# )
echo ">>>Importing users/group into the LDAP system"
$LDAP_HOME/bin/import-ldif -b dc=example,dc=com -n userRoot -l $CURRENT_PRACTICE/ldap/solution.ldif
# start the LDAP server
echo ">>>Starting the LDAP Server"
$LDAP_HOME/bin/start-ds
# set up the environment for WLST
source /u01/app/fmw/wlserver/server/bin/setWLSEnv.sh
# run the script to create the external LDAP authentication provider
java weblogic.WLST create_ldap_provider.py

# run the script to stop all the managed servers in cluster2
java weblogic.WLST stop_cluster.py
# now restart them
java weblogic.WLST start_cluster.py
echo ">>>Now you need to go to host01 and deploy the app and stop and start the admin server."
echo ">>>Find its window. Press Ctrl+C. Then run ./startWebLogic.sh"

