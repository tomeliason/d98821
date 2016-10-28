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
# 2016-10-28 AJS Added support for proxy to generated ~/.ssh/config file
#
#

#
# First configure common environment scripts, functions etc
# Common functions go into the /practices/utils, single use functions are here.
source /practices/util/setenv.sh


#
# SSH public and private keys are stored by default into ~/.ssh/
# This function copies these files from /practices/common to make sure all are insynch with the
# preconfigured JCS environment
#
function setupSSH() {

	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	#
	# SSH public and private keys are stored by default into
	# ~/.ssh/ if it doesn't exist create it
	#

	if [[ ! -d ~/.ssh ]]; then
		if [[ "$debug" = "1" ]]; then
			echo "Making ~/.ssh"
		fi
		mkdir ~/.ssh
	fi

	#
	# Now seed the directory with /practices/common/id*
	# 
	if [[ -e ~/.ssh/id_rsa.pub || -e ~/.ssh/id_rsa  ]]; then
		
		echo "Found existing SSH Keys, ~/.ssh/id_rsa*"
		while true ; do
			read -p "Overwrite? Y/n [Y]" answer
			# default is yes
			if [[ -z "$answer" ]]; then
				answer="Y"
			fi
			case $answer in
			   [yY]* )
				echo "Removing and replacing existing SSH keys"
				rm -rf ~/.ssh/id_rsa* >> /dev/null 2>&1 
				break ;;	
			   [nN]* ) 
				echo "Retaining existing SSH keys"
				return 0;
				exit ;;
			   * )  echo "unknown value '$answer'"; 
				continue ;;
			esac
		done

	fi

	if [[ "$debug" = "1" ]]; then
		echo "Copying files from /practices/common/id_rsa* to ~/.ssh/"
		cp -v /practices/common/id_rsa* ~/.ssh/
	else
		cp /practices/common/id_rsa* ~/.ssh/
	fi
	echo "~/.ssh/ seeded with common SSH Keys"
	return 0
}

#
# 
#

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


#
# Now set up SSH Keys
#
setupSSH

#
# And finally, create an ssh config file with a remote host proxy vale
#
getProperty wls_ip /practices/common/common.properties
#
# We should tell if we are overwriting...
#
if [[ -e ~/.ssh/config ]]; then
	rm -rf ~/.ssh/config >> /dev/null 2>&1
fi
getProperty wls_ip /practices/common/common.properties
proxyIp=$resultValue
echo "#" > ~/.ssh/config 
echo "# Generated do not update" >> ~/.ssh/config 
echo "#" >> ~/.ssh/config 
echo "Host remotehost-proxy" >> ~/.ssh/config 
echo "    HostName $proxyIp" >> ~/.ssh/config 
echo "    ControlPath ~/.ssh/remotehost-proxy.ctl" >> ~/.ssh/config 
echo "Created ~/.ssh/config"

echo "Completed!"


