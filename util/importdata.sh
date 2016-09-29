#!/bin/bash

identitydomain=ouopc005
username=tom.eliason@oracle.com
password=Welc0me1
servicename=DB 
storagename=mystorage1
authtoken=none
dbcsendpoint=https://dbcs.emea.oraclecloud.com
dbcshost=140.86.33.155
sshpublickey=none
sshprivatekey=none

sshpublickey=$(<~/.ssh/id_rsa.pub)
sshprivatekey=$(<~/.ssh/id_rsa)

#scp wlsadmin.oracle.dmp oracle@${dbcshost}:/home/oracle

ssh oracle@${dbcshost} "echo \"create or replace directory o_home as '/home/oracle';\" | sqlplus system/Welcome_1@PDB1 "

ssh oracle@${dbcshost} "impdp system/Welcome_1@PDB1 DIRECTORY=O_HOME DUMPFILE=wlsadmin.oracle.dmp FULL=Y"

echo "finished importing data"
