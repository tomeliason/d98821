# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# create data source to DBCS
# deploy auction app to JCS using data source
# attempt to perform a GET that accesses the auction app and uses the database

identitydomain=ouopc005
username=tom.eliason@oracle.com
password=Welc0me1
servicename=DB
jcsservicename=JCS
storagename=mystorage1
authtoken=none
dbcsendpoint=https://dbcs.emea.oraclecloud.com
jcsendpoint=https://jcs.emea.oraclecloud.com
sshpublickey=none
jcshost=140.86.34.161
wlsusername=weblogic
wlspassword=Welcome_1

WL_HOME=c:/oracle/wls1221/wlserver
MW_HOME=c:/oracle/wls1221

#mkdir /u01/domains/part1/wlsadmin/apps
#cp benefits.war /u01/domains/part1/wlsadmin/apps/benefits.old
#cp /practices/part1/practice10-01/update/benefits.war /u01/domains/part1/wlsadmin/apps/benefits.war

ssh -i ~/.ssh/id_rsa -f -N -T -M -L 7001:140.86.34.161:7001 opc@remotehost-proxy
curl -v -u ${wlsusername}:${wlspassword} -H "X-Requested-By:MyClient" -H Accept:application/json -H Content-Type:multipart/form-data -F "model={name:'benefits',targets:['JCS_Cluster']}" -F "deployment=@./benefits.war" -X POST http://localhost:7001/management/wls/latest/deployments/application
ssh -T -O "exit" remotehost-proxy

#scp benefits.war opc@140.86.34.161:/home/opc
#ssh -i ~/.ssh/id_rsa -f -N -T -M -L 9001:140.86.34.161:9001 opc@remotehost-proxy
#source $WL_HOME/server/bin/setWLSEnv.sh
#java weblogic.WLST deploy_app.py
#ssh -T -O "exit" remotehost-proxy
