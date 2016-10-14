#!/bin/bash

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


#
#
#
#confirmJCSEnvironment /practices/common/common.properties
# $1 file 
# return value
#	0 success
#	1 file argument missing
#   2 property file provided but does not exist/cannot be found.
#   3 various cURL errors, see errorValue for text of full error
#   4 missing certificate file
#
# returns error in variable errorValue on error
#
function confirmJCSEnvironment() {

	local propertyfile=$1
	local originalDebug=$debug # so we can turn debug off if we want.

	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	if [[ $# -lt 1 ]]; then
		errorValue="Error: Missing property file.  ${FUNCNAME} "
		echo "$errorValue"
		echo "Usage confirmJCSEnvironment property.file [curlOutput results file]"
		return 1
	fi
	local outputFile=""
	if [[ $# -eq 2 ]]; then
		outputFile=$2
		if [[ "$debug" = "1" ]]; then
			echo "Using '$outputFile' for output, which may be empty"
		fi
	fi
	#
	# Got a properties file
	# see if file exists
	if [ ! -f $propertyfile ]; then
       		echo "Property file '$propertyfile' not found" 
	       	errorValue="Error: Property file '$propertyfile' not found"
       		return 2
	fi

	#
	# Setup environment
	# Assumes the function configureUserVariables has already been called and the user has correctly updated any environment variables
	# 
	#unset debug
	exportProperties $propertyfile
	#debug="1"
	
	#
	# Basic curl common stuff
	#
	local curlCommonArguments="-# -f -k -i" # --silent, do not output anything
 	                                        #-# on windows say display status bar, which interestingly enough means no status bar
	                                        #-f fail on error, -k insecure, -i include header information in output
	local curlCredentials="-u ${opcUsername}:${opcPassword}"
	local curlHeader="-H X-ID-TENANT-NAME:${identityDomain}"
	# in theory JCSEndpoint starts with https://
	local curlBaseURL="${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName}"
	#
	# Attempt to access the JCS instance at its root
	#
    curlCOMMAND="curl ${curlCommonArguments} -X GET ${curlCredentials} ${curlHeader} ${curlBaseURL}"
	#STATUSCODE=$(curl --silent --output /dev/stderr --write-out "%{http_code}" URL)
	if [[ "$debug" = "1" ]]; then
		echo
		echo "Executing command '$curlCOMMAND' "
		echo "Using elements:"
		echo "  curlCommonArguments ='${curlCommonArguments}'"
		echo "  curlCredentials ='${curlCredentials}'"
		echo "  curlHeader ='${curlHeader}'"
		echo "  curlBaseURL ='${curlBaseURL}'"	
		echo
	fi
	echo `$curlCOMMAND`
    curlResult=$($curlCOMMAND) > /dev/null 2>&1
	curl_status=$?
	if [[ -n "$outputFile" ]]; then
		echo "" > $outputFile
		echo "Curl Command: ${curlCOMMAND}" >> $outputFile
		echo "Output: $curlResult" >> $outputFile
		echo "" >> $outputFile
	fi
	#echo curl_status=$curl_status
	if [[ "$curl_status" != 0 ]]; then
	    errorValue="Error, curl failed with status '$curl_status'"
		errorValue="${errorValue}
Check the value of:"
		errorValue="${errorValue}
	Credentials: username=${opcUsername}:${opcPassword}"
		errorValue="${errorValue}
	Identify domain: ${identityDomain}"
		errorValue="${errorValue}
	JCS Endpoing: ${JCSEndpoint}"
		echo "$errorValue"
		return 1
	else
		echo "Successfully contacted Cloud Service:'${JCSServiceName}' at end point '${JCSEndpoint}' for identify domain: '${identityDomain}' with credentials:'${opcUsername}:******'"
	fi
	
	#
	# Now store off the results
	#
	local wls_admin_url=`echo $curlResult | sed -e 's/^.*"wls_admin_url"[ ]*:[ ]*"//' -e 's/".*//'`
	local otd_admin_url=`echo $curlResult | sed -e 's/^.*"otd_admin_url"[ ]*:[ ]*"//' -e 's/".*//'`
	local wls_ip=`echo $wls_admin_url | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`
	local otd_ip=`echo $otd_admin_url | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`

	setProperty wls_admin_url $wls_admin_url $propertyfile
	setProperty otd_admin_url $otd_admin_url $propertyfile
	setProperty wls_ip $wls_ip $propertyfile
	setProperty otd_ip $otd_ip $propertyfile


	#
	# Now the database, which requires a cert
	#

	#
	# First validate that we have a cert 
	# 
	local certFile="${UTILITY_DIR}/cacert.pem"
	
	if [[ "$debug" = "1" ]]; then
		echo
		echo " Using Certificate '${certFile}'"
		echo
	fi
	if [ ! -f $certFile ]; then
		if [[ "$debug" = "1" ]]; then
			echo "File $certFile not found."
		fi
		errorValue="Error cannot find expected certificate file '$certFile'. Cannot validate database"
		return 4
	fi
	
	# For JCS curlBaseURL="${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName}"
	curlBaseURL="${DBCSEndpoint}/paas/service/dbcs/api/v1.1/instances/${identityDomain}/${DBCSServiceName}"
    curlCOMMAND="curl ${curlCommonArguments} --cacert $certFile -X GET ${curlCredentials} ${curlHeader} ${curlBaseURL}"
	if [[ "$debug" = "1" ]]; then
		echo
		echo "Executing command '$curlCOMMAND' "
		echo "Using elements:"
		echo "  curlCommonArguments ='${curlCommonArguments}'"
		echo "  curlCredentials ='${curlCredentials}'"
		echo "  curlHeader ='${curlHeader}'"
		echo "  curlBaseURL ='${curlBaseURL}'"		
		echo
	fi
	curlResult=$($curlCOMMAND) > /dev/null 2>&1
	curl_status=$?
	if [[  -n "$outputFile" ]]; then
		echo "" >> $outputFile
		echo "Curl Command: ${curlCOMMAND}" >> $outputFile
		echo "Output: $curlResult" >> $outputFile
		echo "" >> $outputFile
	fi
	#echo curl_status=$curl_status
	if [[ "$curl_status" != 0 ]]; then
	    errorValue="Error, curl failed with status '$curl_status'"
		errorValue="${errorValue}
Check the value of:"
		errorValue="${errorValue}
	Credentials: username=${opcUsername}:${opcPassword}"
		errorValue="${errorValue}
	Identify domain: ${identityDomain}"
		errorValue="${errorValue}
	DBCS Endpoing: ${DBCSServiceName}"
		echo "$errorValue"
		return 1
	else
		echo "Successfully contacted Cloud Service:'${DBCSServiceName}' at end point '${DBCSEndpoint}' for identify domain: '${identityDomain}' with credentials:'${opcUsername}:******'"
	fi

	
	local db_address=`echo $curlResult | sed -e 's/^.*"em_url"[ ]*:[ ]*"//' -e 's/".*//'`
	local db_connect=`echo $curlResult | sed -e 's/^.*"connect_descriptor_with_public_ip"[ ]*:[ ]*"//' -e 's/".*//'`
	local db_ip=`echo $db_address | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"`
	
	setProperty db_address $db_address $propertyfile
	setProperty db_connect $db_connect $propertyfile
	setProperty db_ip $db_ip $propertyfile
	
	echo WLS ADMIN URL: ${wls_admin_url}
	echo OTD ADMIN URL: ${otd_admin_url}
	echo DB ADDRESS: ${db_address}
	echo DB CONNECT: ${db_connect}
	echo WLS ADMIN IP: ${wls_ip}
	echo OTD IP: ${otd_ip}
	echo DB IP: ${db_ip}
	return 0
}
