#!/bin/bash

identitydomain=ouopc005
username=tom.eliason@oracle.com
password=Welc0me1
servicename=DevOpsDB 
storagename=mystorage1
authtoken=none
dbcsendpoint=https://dbcs.emea.oraclecloud.com
sshpublickey=none
sshprivatekey=none

rm -rf ~/.ssh/id_rsa
rm -rf ~/.ssh/id_rsa.pub

echo -ne '\n\n' | ssh-keygen -b 2048 -t rsa
sshpublickey=$(<~/.ssh/id_rsa.pub)
sshprivatekey=$(<~/.ssh/id_rsa)

echo "created ssh key"

authtoken=$(curl -X GET -sS -I -v -H "X-Storage-User: Storage-${identitydomain}:${username}" -H "X-Storage-Pass: ${password}" https://${identitydomain}.storage.oraclecloud.com/auth/v1.0 | grep X-Auth-Token | awk {'print $2'})

echo "obtained authorization token"

curl -v -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}

curl -v -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}

curl -v -I -sS -X DELETE -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}Archive

curl -v -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}Archive

echo "created storage"

curl -v -I -sS -X PUT -H "X-Auth-Token: ${authtoken}" -T ~/.ssh/id_rsa  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}/id_rsa

curl -v -I -sS -X PUT -H "X-Auth-Token: ${authtoken}"  -T ~/.ssh/id_rsa.pub  https://${identitydomain}.storage.oraclecloud.com/v1/Storage-${identitydomain}/${storagename}/id_rsa.pub

echo "storing ssh keys"

curl -v --include --request POST --cacert ~/cacert.pem --user ${username}:${password} --header "X-ID-TENANT-NAME:${identitydomain}" --header "Content-Type:application/json" --data "{ \"description\": \"Example service instance\",  \"edition\": \"EE\",  \"level\": \"PAAS\",  \"serviceName\": \"${servicename}\",  \"shape\": \"oc3\",  \"subscriptionType\": \"MONTHLY\",  \"version\": \"12.1.0.2\",  \"vmPublicKeyText\": \"${sshpublickey}\",  \"parameters\": [ { \"type\": \"db\", \"usableStorage\": \"15\", \"adminPassword\": \"Welcome_1\", \"sid\": \"ORCL\", \"pdbName\": \"PDB1\", \"failoverDatabase\": \"no\", \"backupDestination\": \"BOTH\", \"cloudStorageContainer\": \"Storage-${identitydomain}\/${storagename}\", \"cloudStorageUser\": \"${username}\", \"cloudStoragePwd\": \"${password}\" } ] }" ${dbcsendpoint}/paas/service/dbcs/api/v1.1/instances/${identitydomain}

echo "submitted dbcs for creation"
