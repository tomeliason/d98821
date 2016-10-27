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
if [[ ! -f /practices/admin/.initialized ]] ; then
	echo ". /practices/util/setenv.sh" >> $HOME/.bashrc
fi

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
	#echo "sourcing $CURRENT_DIR/$file"
done

#
# Add the current directory to the common properties file as UTILITY_DIR
#
setProperty UTILITY_DIR $CURRENT_DIR  /practices/common/common.properties

#
# Export all common.properties
#  
exportProperties /practices/common/common.properties

#
# Automatically set up wls env
# WL_HOME comes from common.properties via exportProperties
#
if [ -z `echo $CLASSPATH | grep "wls.classpath.jar"` ]; then
    . "${WL_HOME}/server/bin/setWLSEnv.sh" >/dev/null
fi

# JAVA_HOME comes from common.properties via exportProperties

export PATH=`echo $PATH | sed "s=:$JAVA_HOME/bin==g"`:$JAVA_HOME/bin

