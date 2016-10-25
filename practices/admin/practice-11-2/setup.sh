# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# -- 
# ------------------------------------------------------------------------

# (re)initialize the database
$ORACLE_HOME/bin/sqlplus oracle/Welcome1 << EOF

set echo off
set heading off

@init_database.sql;

exit;

EOF
