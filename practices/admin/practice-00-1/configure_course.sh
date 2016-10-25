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

#
# First configure common environment scripts, functions etc
#
source /practices/util/setenv.sh

if [[ -f /practices/admin/.initialized ]] ; then
	
	echo "Environment already initialized."
	read -p "Continue? Y/n [Y]" answer
	if [[ -z "$answer" ]]; then
		answer="Y"
	fi

	case $answer in
	   [yY]* )
		echo "Continueing"
		;;

	   * ) 
		echo "Exiting"
		return 0
	  esac
else
	echo "Admin course initialized" > /practices/admin/.initialized 2>&1  
fi

echo ""
echo "Welcome to the configure course environment script"
echo "This script will ask a few questions and then configure environment variables as required"
echo "If you do not know an answer, discuss with your instructor or a lab aide"
echo "You will need the values for the following:"
#
# Note this is a duplication of the same set in environmentSupport.sh
#
propertySet="identityDomain opcUsername opcPassword DBCSEndpoint JCSEndpoint RootPWD"
echo " $propertySet"

echo "Are you ready to  configure the course environment?"

while true ;
	do
	read -p "Continue? Y/n [Y]" answer

	# default is yes
	if [[ -z "$answer" ]]; then
		answer="Y"
	fi

	case $answer in
	   [yY]* )
		echo "Continueing"
		break ;;
		# exit ;;

	   [nN]* ) 
		echo "Exiting"
		return 0;
		exit ;;
	   * )     echo "unknown value '$answer'"; 
		continue ;;
	  esac
done
#
# First configure common environment scripts, functions etc
#
source ../../util/setenv.sh

#
# Now configure the course variables
#
configureUserVariables /practices/common/common.properties


#
# Now attempt to determine the names and otherwise confirm that the environment variables are correct
#
echo "Attempting to confirm Cloud environment, this could take a few moments"
confirmJCSEnvironment /practices/common/common.properties
confirmStatus=$?
if [[ "$confirmStatus" != 0 ]]; then
	echo "Error confirming Cloud environment"
	echo "$errorValue"
	return 1 # failed
fi

#
# Ok, passed confirm, write host values to /etc/hosts
#
getProperty RootPWD /practices/common/common.properties
rootPWD=$resultValue

getProperty otd_ip /practices/common/common.properties
addToEtcHosts otdhost $resultValue $rootPWD

getProperty db_ip /practices/common/common.properties
addToEtcHosts dbhost $resultValue $rootPWD

getProperty wls_ip /practices/common/common.properties
addToEtcHosts jcshost $resultValue $rootPWD

echo "Completed!"


