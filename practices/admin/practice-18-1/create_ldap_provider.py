# Creates the new external LDAP authentication provider
# as if you followed the instructions 
# in the practice "Creating an Authentication Provider"
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

# variables
url = 't3://host01.example.com:7001'
domainname = 'wlsadmin'
username = 'weblogic'
password = 'Welcome1'
realmname = 'myrealm'
providername = 'CompanyLDAP'
defaultprovidername = 'DefaultAuthenticator'
controlflag = 'SUFFICIENT'
providerhost = 'host02.example.com'
providerport = 7878
principal = 'cn=Directory Manager'
credential = 'Welcome1'
userbasedn = 'dc=example,dc=com'
usernameattrib = 'uid'
groupbasedn = 'dc=example,dc=com'
groupnameattrib = 'cn'

# Connect to administration server
connect(username, password, url)

# Check if provider already exists
try:
	cd('/SecurityConfiguration/' + domainname + '/Realms/' + realmname + '/AuthenticationProviders/' + providername)
	print '>>>The Authentication Provider ' + providername + ' already exists.'
	exit()
except WLSTException:
	pass

print '>>>Creating new Authentication Provider named ' + providername + '.'

edit()
startEdit()
cd('/')


# Create provider
realm = getMBean('/SecurityConfiguration/' + domainname + '/Realms/' + realmname)
provider = realm.createAuthenticationProvider(providername, 'weblogic.security.providers.authentication.LDAPAuthenticator')
provider.setControlFlag(controlflag)
provider.setHost(providerhost)
provider.setPort(providerport)
provider.setPrincipal(principal)
provider.setCredential(credential)
provider.setUserBaseDN(userbasedn)
provider.setUserNameAttribute(usernameattrib)
provider.setGroupBaseDN(groupbasedn)
provider.setStaticGroupNameAttribute(groupnameattrib)
provider.setCacheEnabled(false)

# Change the control flag of the default authentication provider
cd('/SecurityConfiguration/' + domainname + '/Realms/' + realmname + '/AuthenticationProviders/' + defaultprovidername)
cmo.setControlFlag(controlflag)

# Reorder the authentication providers (new one, embedded LDAP, default asserter)
cd('/SecurityConfiguration/' + domainname + '/Realms/' + realmname)
set('AuthenticationProviders',jarray.array([ObjectName('Security:Name=myrealmCompanyLDAP'), ObjectName('Security:Name=myrealmDefaultAuthenticator'), ObjectName('Security:Name=myrealmDefaultIdentityAsserter')], ObjectName))

# Activate changes
save()
activate(block='true')
print '>>>Authentication Provider created successfully.'
exit()
