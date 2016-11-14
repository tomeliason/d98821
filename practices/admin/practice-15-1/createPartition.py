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
#   - WLSDeployPort  - Port of the Admin Server - Administration Port
#   - WLSUsername    - Admin User
#   - WLSPassword    - Admin Password
#   - WLSClusterName - Target Cluster

#Conditionally import wlstModule only when script is executed with jython
if __name__ == '__main__': 
    from wlstModule import *#@UnusedWildImport
    
import sys;

url = 't3://' + os.getenv('WLSAdminHost') + ':' + os.getenv('WLSAdminPort')
username = os.getenv('WLSUsername')
password = os.getenv('WLSPassword')

clustername = os.getenv('WLSClusterName')

virtualTarget="exampleVT"
virtualTargetPrefix='/example'
partitionName = 'exampleDP'

# Connect to administration server
connect(username, password, url)
print '>>> Connected to domain'

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

print '>>> Creating new virtualTarget ' + virtualTarget + '.'

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

print '>>> Creating new domain partition  ' + partitionName + '.'

cd ('/')
cmo.createPartition(partitionName)

cd('/Partitions/'+partitionName+'/SystemFileSystem/'+partitionName)
cmo.setRoot('/u01/data/domains/JCS_domain/partitions/'+partitionName+'/system')
cmo.setCreateOnDemand(true)
cmo.setPreserved(true)

cd('/Partitions/'+partitionName)
cmo.setRealm(getMBean('/SecurityConfiguration/wlsadmin/Realms/myrealm'))
cmo.createResourceGroup('default')
set('AvailableTargets',jarray.array([ObjectName('com.bea:Name='+virtualTarget+',Type=VirtualTarget')], ObjectName))
set('DefaultTargets',jarray.array([ObjectName('com.bea:Name='+virtualTarget+',Type=VirtualTarget')], ObjectName))

activate(block='true')
print 'activated newly created partition'

domain=getMBean('/')
startPartitionWait(domain.lookupPartition(partitionName))

disconnect()

exit()
