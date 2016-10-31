#!/bin/bash

# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# setup script

# function to create a JDBC Data Source named datasource1 using WLST
createJDBCDataSource_datasource1() {
    
    echo "setting up ssh tunnel for WLST"
    echo ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    ssh -i ~/.ssh/id_rsa -f -N -T -M -L ${WLSAdminPort}:${JCSHost}:${WLSAdminPort} opc@remotehost-proxy

    source $WL_HOME/server/bin/setWLSEnv.sh
    
    java weblogic.WLST create_data_source.py

    echo ssh -T -O "exit" remotehost-proxy
    ssh -T -O "exit" remotehost-proxy
    echo "terminating ssh tunnel for WLST"

}

# if this script is called as a main script, execute the function 
if [ ${0##*/} == "setup.sh" ] ; then

        echo ">>> Setting up the practice environment for Practice 11-3"

        echo ">>> Creating contact data"
        
        ssh oracle@${dbcshost} "echo \"ALTER USER 'ORACLE' IDENTIFIED BY 'ORACLE' DEFAULT TABLESPACE 'USERS' TEMPORARY TABLESPACE 'TEMP' ACCOUNT UNLOCK;\" | sqlplus system/Welcome_1@PDB1 "

        ssh oracle@${dbcshost} "echo \"ALTER USER 'ORACLE' DEFAULT ROLE 'DBA','CONNECT','RESOURCE';\" | sqlplus system/Welcome_1@PDB1 "

        ssh oracle@${dbcshost} "echo \"DROP SEQUENCE SEQ_CONTACT;

        ssh oracle@${dbcshost} "echo \"DROP TABLE CONTACTS;

        ssh oracle@${dbcshost} "echo \"CREATE TABLE CONTACTS (CONTACT_ID NUMBER(10) NOT NULL, FIRST_NAME VARCHAR2(40), LAST_NAME VARCHAR2(40) NOT NULL, STREET VARCHAR2(60), CITY VARCHAR2(40), STATE VARCHAR2(30), ZIPCODE VARCHAR2(10), HOME_PHONE VARCHAR2(20), WORK_PHONE VARCHAR2(20), MOBILE_PHONE VARCHAR2(20), PRIMARY KEY (CONTACT_ID));\" | sqlplus system/Welcome_1@PDB1 "

        ssh oracle@${dbcshost} "echo \"CREATE SEQUENCE SEQ_CONTACT INCREMENT BY 1 START WITH 1 NOMAXVALUE NOMINVALUE NOCYCLE NOORDER;\" | sqlplus system/Welcome_1@PDB1 "

        ssh oracle@${dbcshost} "echo \"INSERT INTO CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,STREET,CITY,STATE,ZIPCODE,HOME_PHONE,WORK_PHONE,MOBILE_PHONE) VALUES (SEQ_CONTACT.NEXTVAL,'Homer','Simpson','742 Evergreen Terrace','Springfield','IL','62701','555-123-4567','555-326-4323','555-263-6334');\" | sqlplus system/Welcome_1@PDB1 "

        ssh oracle@${dbcshost} "echo \"INSERT INTO CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,STREET,CITY,STATE,ZIPCODE,HOME_PHONE,WORK_PHONE,MOBILE_PHONE) VALUES (SEQ_CONTACT.NEXTVAL,'Joe','Friday','714 West Sunset Boulevard','Los Angeles','CA','90026','555-321-0714','555-321-7140','555-321-7777');\" | sqlplus system/Welcome_1@PDB1 "
        
        ssh oracle@${dbcshost} "echo \"INSERT INTO CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,STREET,CITY,STATE,ZIPCODE,HOME_PHONE,WORK_PHONE,MOBILE_PHONE) VALUES (SEQ_CONTACT.NEXTVAL,'Jerome','Howard','1762 Bay Ridge Parkway','Brooklyn','NY', '11204','555-980-0384','555-980-8374','555-980-2341');\" | sqlplus system/Welcome_1@PDB1 "

        ssh oracle@${dbcshost} "echo \"INSERT INTO CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,STREET,CITY,STATE,ZIPCODE,HOME_PHONE,WORK_PHONE,MOBILE_PHONE) VALUES (SEQ_CONTACT.NEXTVAL,'Kate','Bell','2525 Millbrook Drive','Raleigh','NC','27615','555-327-5519','555-327-0099','555-327-7548');\" | sqlplus system/Welcome_1@PDB1 "
        
        ssh oracle@${dbcshost} "echo \"INSERT INTO CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,STREET,CITY,STATE,ZIPCODE,HOME_PHONE,WORK_PHONE,MOBILE_PHONE) VALUES (SEQ_CONTACT.NEXTVAL,'Peter','Parker','738 Winter Garden Drive','Queens','NY', '11375','555-444-3535','555-444-0778','555-444-2090');\" | sqlplus system/Welcome_1@PDB1 "
        
        ssh oracle@${dbcshost} "echo \"COMMIT;\" | sqlplus system/Welcome_1@PDB1 "

        echo ">>> Finished creating data"
        
        echo ">>> Creating data source"

        createJDBCDataSource_datasource1

        echo ">>> Finished creating data source"
        
        echo ">>> Practice 11-3 environment has been setup."

fi
