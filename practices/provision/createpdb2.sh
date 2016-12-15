#!/bin/bash

usage() {
cat << EOF

Usage: createpdb2.sh -i [database host name or ip address] -d [identitydomain] [-n] [-u] [-p] [-o] [-s] [-j]
  
Parameters:
   -i: database host name or ip address. Required.
   -d: identity domain. Required.
   -n: name of the pdb to create, defaults to PDB2
   -u: username, defaults to sys as sysdba
   -p: password, defaults to Welcome_1
   -o: oracle home, defaults to /u01/app/oracle/product/12.1.0/dbhome_1/
   -s: source pdb, defaults to PDB1
   -j: database instance, defaults to DB

EOF
exit 0
}

if [ "$#" -eq 0 ]; then usage; fi

# Parameters
username='sys as sysdba'
password=Welcome_1
pdbname=PDB2
sourcepdb=PDB1
dbcshost=
dbcsinstance=DB
identitydomain=
oraclehome=/u01/app/oracle/product/12.1.0/dbhome_1/

OPTIND=1

while getopts "h:n:u:p:o:i:d:s:j:" optname; do
  case "$optname" in
    "h")
      usage
      ;;
    "i")
      dbcshost=$OPTARG
      echo $1 $2 $3 ${optname} ${OPTARG} ${OPTIND}
      ;;
    "d")
      identitydomain=$OPTARG
      ;;
    "n")
      pdbname=$OPTARG
      ;;
    "s")
      sourcepdb=$OPTARG
      ;;
    "u")
      username=$OPTARG
      ;;
    "p")
      password=$OPTARG
      ;;
    "o")
      oraclehome=$OPTARG
      ;;
    "j")
      dbcsinstance=$OPTARG
      ;;
    \?)
    # Should not occur
      echo "Unknown error while processing options inside createpdb2.sh"
      ;;
  esac
done

echo "creating PDB with options i="${dbcshost}" d="${identitydomain}" n="${pdbname}" u="${username}" p="${password}" o="${oraclehome}" s="${sourcepdb}" j="${dbcsinstance}

ssh oracle@${dbcshost} "echo \"alter pluggable database "${sourcepdb}" close immediate;\" | sqlplus / as sysdba "

ssh oracle@${dbcshost} "echo \"alter pluggable database "${sourcepdb}" open read only force;\" | sqlplus / as sysdba "

ssh oracle@${dbcshost} "echo \"create pluggable database "${pdbname}" from "${sourcepdb}";\" | sqlplus / as sysdba "

ssh oracle@${dbcshost} "echo \"alter pluggable database "${pdbname}" open read write force;\" | sqlplus / as sysdba "

ssh oracle@${dbcshost} "echo \"alter pluggable database "${sourcepdb}" close immediate;\" | sqlplus / as sysdba "

ssh oracle@${dbcshost} "echo \"alter pluggable database "${sourcepdb}" open read write force;\" | sqlplus / as sysdba "

ssh oracle@${dbcshost} "echo \""${pdbname}" = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = "${dbcsinstance}".compute-${identitydomain}.oraclecloud.internal)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = "${pdbname}"."${identitydomain}".oraclecloud.internal) ) )\" >> "${oraclehome}"network/admin/tnsnames.ora "

ssh oracle@${dbcshost} "lsnrctl stop"

ssh oracle@${dbcshost} "lsnrctl start"

echo "lsrnctl status"

echo "finished creating PDB"
