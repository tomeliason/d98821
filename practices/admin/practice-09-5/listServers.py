#
# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# ------------------------------------------------------------------------

if __name__ == '__main__': 
    from wlstModule import *#@UnusedWildImport
    

import sys;
# get operating system (for vars)
import os

# variables
url = 't3://' + os.getenv('WLSAdminHost') + ':' + os.getenv('WLSAdminPort')
username = os.getenv('WLSUsername')
password = os.getenv('WLSPassword')

print '>>>Connecting to ' + url

# Connect to administration server
connect(username, password, url)

print 'Connected to domain'


mbServers= getMBean("Servers")
servers= mbServers.getServers()
print( "Servers: " )
print( servers )
for server in servers :
     print( "Server Name: " + server.getName() )
print( "Done." )
disconnect()
exit()

