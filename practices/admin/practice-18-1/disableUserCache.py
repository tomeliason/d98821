#
# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# ------------------------------------------------------------------------

# variables
url = 't3://host01.example.com:7001'
domainname = 'wlsadmin'
username = 'weblogic'
password = 'Welcome1'
realmname = 'myrealm'
providername = 'CompanyLDAP'
credential = 'Welcome1'

# Connect to administration server
connect(username, password, url)

# Ensure provider already exists
try:
	pass
except WLSTException:
	cd('/SecurityConfiguration/' + domainname + '/Realms/' + realmname + '/AuthenticationProviders/' + providername)
	print '>>>The Authentication Provider ' + providername + ' does not exist, exiting.'
	exit()

print '>>>Disabling Cache for Authentication Provider: ' + providername + '.'

edit()
startEdit()
cd('/')

# Create provider
provider = getMBean('/SecurityConfiguration/' + domainname + '/Realms/' + realmname + '/AuthenticationProviders/' + providername)
provider.setCacheEnabled(false)

# Activate changes
save()
activate(block='true')
print '>>>Authentication Provider cache is disabled.'
exit()
