# By: ST Curriculum Development Team
# Version 1.0
# Last updated: May 22, 2013
#
# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# ------------------------------------------------------------------------

# get operating system (for vars)
import os

# variables
url = 't3://' + os.getenv('WLSAdminHost') + ':' + os.getenv('WLSAdminPort')
username = os.getenv('WLSUsername')
password = os.getenv('WLSPassword')

print '>>>Connecting to ' + url

# Connect to administration server
connect(username, password, url)

# Print environment
print version
print domainName
print serverName

print '>>>Script completed successfully!'
exit()

