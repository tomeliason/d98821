# Creates the same data source as if you followed the instructions for 
# the practice "Configuring a JDBC Data Source"
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
import sys

# variables
url = 't3://' + os.getenv('WLSAdminHost') + ':' + os.getenv('WLSAdminPort')
username = os.getenv('WLSUsername')
password = os.getenv('WLSPassword')

print url

dsname = 'jdbc.AuctionDatabase'
jndiname = 'jdbc/AuctionDatabase'
clustername = os.getenv('WLSClusterName')
initialcap = 1
maxcap = 5
mincap = 1
cachetype = 'LRU'
cachesize = 15
testreserve = true
testfreq = 240
trustidle = 60
shrink = 300
drivername = 'oracle.jdbc.xa.client.OracleXADataSource'
#driverurl = 'jdbc:oracle:thin:@DB:1521/PDB1.ouopc005.oraclecloud.internal'
driverurl = os.getenv('DBCSURL')
driveruser = os.getenv('DBCSAuctionUsername')
driverpassword = os.getenv('DBCSAuctionPassword')
testtable='SQL SELECT 1 FROM DUAL'

# Connect to administration server
connect(username, password, url)

# Check if data source already exists
try:
	cd('/JDBCSystemResources/' + dsname)
	print '>>> The JDBC Data Source ' + dsname + ' already exists.'
	exit()
except WLSTException:
	pass

print '>>> Creating a new generic JDBC data source named ' + dsname + '.'

# start an edit session
edit()
# lock the configuration
startEdit()


# Save a reference to the target cluster
cd('/Clusters')
cd(clustername)
target = cmo

# go back to the root
cd('/')

# Create data source
jdbcresource = create(dsname, 'JDBCSystemResource')
theresource = jdbcresource.getJDBCResource()
theresource.setName(dsname)

# Set JNDI name
jdbcresourceparams = theresource.getJDBCDataSourceParams()
jdbcresourceparams.setJNDINames([jndiname])
jdbcresourceparams.setGlobalTransactionsProtocol('TwoPhaseCommit')

# Create connection pool
pool = theresource.getJDBCConnectionPoolParams()
pool.setInitialCapacity(initialcap)
pool.setMaxCapacity(maxcap)
pool.setMinCapacity(mincap)
pool.setStatementCacheType(cachetype)
pool.setStatementCacheSize(cachesize)
pool.setTestConnectionsOnReserve(testreserve)
pool.setTestFrequencySeconds(testfreq)
pool.setSecondsToTrustAnIdlePoolConnection(trustidle)
pool.setShrinkFrequencySeconds(shrink)
pool.setTestTableName(testtable)

# Create driver settings
driver = theresource.getJDBCDriverParams()
driver.setDriverName(drivername)
driver.setUrl(driverurl)
driver.setPassword(driverpassword)
driverprops = driver.getProperties()
userprop = driverprops.createProperty('user')
userprop.setValue(driveruser)

# Set data source target
jdbcresource.addTarget(target)

# Activate changes
save()
activate(block='true')
print '>>> Data source created successfully!'
exit()

