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
print 'Connected to domain'

edit()
startEdit()


# Check if virtual target already exists
# fails is existed and was deleted. Cached?
try:
	cd('/VirtualTargets/' + virtualTarget);
	print 'Virtual target ' + virtualTarget + ' already exists.'
	exit()
except WLSTException:
	pass

print 'Creating new virtualTarget ' + virtualTarget + '.'

#domain=getMBean('/')
#domain.createVirtualTarget(virtualTarget)
cd('/')
cmo.createVirtualTarget(virtualTarget)

cd('/VirtualTargets/' + virtualTarget)
cmo.setUriPrefix(virtualTargetPrefix)
set('Targets',jarray.array([ObjectName('com.bea:Name=AdminServer,Type=Server')], ObjectName))

print 'Virtual target' +virtualTarget +' created successfully with prefix '+virtualTargetPrefix+'.'

#
# Now create the domain partition
#

# Check if virtual target already exists
# fails is existed and was deleted. Cached?
try:
	cd('/Partitions/'+partitionName)
	print 'Partition '+ partitionName+' already exists.'
	exit()
except WLSTException:
	pass

print 'Creating new domain partition  ' + partitionName + '.'

cd ('/')
cmo.createPartition(partitionName)

cd('/Partitions/'+partitionName+'/SystemFileSystem/'+partitionName)
cmo.setRoot('/u01/domains/part2/wlsadmin/partitions/'+partitionName+'/system')
cmo.setCreateOnDemand(true)
cmo.setPreserved(true)

cd('/Partitions/'+partitionName)
cmo.setRealm(getMBean('/SecurityConfiguration/wlsadmin/Realms/myrealm'))
cmo.createResourceGroup('default')
set('AvailableTargets',jarray.array([ObjectName('com.bea:Name='+virtualTarget+',Type=VirtualTarget')], ObjectName))
set('DefaultTargets',jarray.array([ObjectName('com.bea:Name='+virtualTarget+',Type=VirtualTarget')], ObjectName))

activate()
print 'activated newly created partition'

disconnect()

exit()
