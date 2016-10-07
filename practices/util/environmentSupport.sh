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
# configureUserVariables /path/to/properties file
# configureUserVariables /practices/common/common.properties
# $1 file 
# return value
#	0 success
#	1 file argument missing
#   2 property file provided but does not exist/cannot be found.
# No return strings, just success or failure
# returns error in variable errorValue on error
#
function configureUserVariables() {

	local propertyfile=$1

    
	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	if [[ $# -ne 1 ]]; then
		errorValue="Error: Missing property file.  ${FUNCNAME} "
		echo "$errorValue"
		return 1
	fi

	# see if file exists
	if [ ! -f $propertyfile ]; then
		errorValue="Error: Property file '$propertyfile' not found"
		echo "$errorValue"
		return 2
	fi


	local propertySet="identityDomain opcUsername opcPassword DBCSEndpoint JCSEndpoint"
	local defaultValue=""
	#
	# Loop over the query propery set querying for each
	#  Use any existing value as a default
	for aproperty in $propertySet; 
	do

		if [[ "$debug" = "1" ]]; then
			echo "processing '$aproperty' in set '$propertySet'"
		fi
		#
		# use the getProperty method to return the default value
		# 
		getProperty $aproperty $propertyfile
		defaultValue=$resultValue
		local userValue
		while : ; do
			echo -n "Please enter a value for $aproperty, return for default [$defaultValue]:"
			read userValue
			if [[ -z "$userValue" && -n "$defaultValue" ]]; then
				# nothing to do
				# there is a default and user entered nothing
				if [[ "$debug" = "1" ]]; then
					echo "Skipping property '$aproperty' user entered default"
				fi
				continue 2; 

			fi
			if [[ "X" = "X$userValue" ]]; then
				echo "Property $aproperty cannot be empty."
				continue
			fi
			break;
		done
		#echo "setProperty $userValue $propertyfile"
		setProperty $aproperty $userValue $propertyfile
	done


	return 0
}
