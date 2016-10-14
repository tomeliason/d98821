#!/bin/bash
#
# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------
#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo "CURRENT_DIR=$CURRENT_DIR as dir"
#
# Strip bin directory from path if its already there
# The add the bin directory to the end of the path
#
#echo setting path = `echo $PATH | sed "s=:$CURRENT_DIR==g"`:$CURRENT_DIR
export PATH=`echo $PATH | sed "s=:$CURRENT_DIR==g"`:$CURRENT_DIR

#
# Set prompt to user@host:\shortened working directory >
#
#echo 'PS1=$PS1'
export PS1='\u@\h:\w >'
#echo  PS1=$PS1

#
# Each time a support file, which is itself a set of bash functions, is created add it here
# there should be an equivalent file in the same directory as the setenv.sh
# seperate entries by spaces

functionsList="propertiesSupport.sh environmentSupport.sh jcstestSupport.sh"
#
# Iterate over the support files sourcing each
#
for file in $functionsList; do 
	source $CURRENT_DIR/$file
	echo "sourcing $CURRENT_DIR/$file"
done

#
# Lastly add the current directory to the common properties file as UTILITY_DIR
#
setProperty UTILITY_DIR $CURRENT_DIR  $CURRENT_DIR/../common/common.properties
