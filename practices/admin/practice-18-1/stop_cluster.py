# Stops all the servers in the dyanmic cluster 
#
# By: ST Curriculum Development Team
# Version 1.0
# Last updated: May 23, 2013
#
# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# ------------------------------------------------------------------------

url = 't3://host01.example.com:7001'
username = 'weblogic'
password = 'Welcome1'
target = 'cluster2'

# Connect to administration server
connect(username, password, url)

print '>>>Stopping the cluster ' + target
shutdown(target,'Cluster', 'true', 0, 'true', 'true')
