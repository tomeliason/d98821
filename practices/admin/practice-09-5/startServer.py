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

print '>>>Connecting to ' + username + '@'+ url 

# Connect to administration server
try:
	connect(username, password, url)
except:
	print('Error connecting to ' + url)
nargs = len(sys.argv)	
if nargs < 1:
	 raise Exception('Invalid Parameters')
	 
instance=sys.argv[1]

print ("Connected to domain, attempting to start '" + instance + "'")
try:
	print("Starting Server "+instance+"")
	start(instance, 'Server')
except:
	print("Error starting Server" + instance)


print( "Done." )
disconnect()
exit()
