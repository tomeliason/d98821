# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------

#Conditionally import wlstModule only when script is executed with jython
if __name__ == '__main__': 
    from wlstModule import *#@UnusedWildImport
    

import sys;

password=''
if ( len (sys.argv) >= 2 ): 
    password=sys.argv[1]

#print "Password = '%s' " % password

url = 'host01:7001'
username = 'weblogic'
virtualTarget="exampleVT"
virtualTargetPrefix='/example'
partitionName = 'exampleDP'


#
# The wrapper script should capture the WLS password
# so in theory we should never be here, but just in case
if (password == ''):
    password = "".join (java.lang.System.console().readPassword("%s",["Please enter the password from the course practice environment: Security Credentials for the weblogi use for Oracle WebLogic Server: "]))
#else:
#    print "using captured password %s" % password


# Connect to administration server
connect(username, password, url)
print 'Connected to domain, starting partition'

domain=getMBean('/')
startPartitionWait(domain.lookupPartition(partitionName))
disconnect()

print 'Starting Domain partition ' + partitionName

exit()
