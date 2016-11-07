#!/bin/bash

sshpublickey=none
sshprivatekey=none

sshpublickey=$(<~/.ssh/id_rsa.pub)
sshprivatekey=$(<~/.ssh/id_rsa)

echo "copying dump file"

scp wlsadmin.oracle.dmp oracle@${DBCSHost}:/home/oracle

echo "configuring"

ssh oracle@${DBCSHost} "echo \"create or replace directory o_home as '/home/oracle';\" | sqlplus ${DBCSUsername}/${DBCSPassword}@PDB1 "

echo "importing data"

ssh oracle@${DBCSHost} "impdp ${DBCSUsername}/${DBCSPassword}@PDB1 DIRECTORY=O_HOME DUMPFILE=wlsadmin.oracle.dmp FULL=Y"

ssh oracle@${DBCSHost} "echo \"ALTER USER \"ORACLE\" IDENTIFIED BY \"ORACLE\" DEFAULT TABLESPACE \"USERS\" TEMPORARY TABLESPACE \"TEMP\" ACCOUNT UNLOCK;\" | sqlplus ${DBCSUsername}/${DBCSPassword}@PDB1 "

ssh oracle@${DBCSHost} "echo \"ALTER USER \"ORACLE\" DEFAULT ROLE \"DBA\",\"CONNECT\",\"RESOURCE\";\" | sqlplus ${DBCSUsername}/${DBCSPassword}@PDB1 "

echo "finished importing data"
