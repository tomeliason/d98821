#!/bin/bash
#
# jcstestSupport.sh
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
# jcsIsRunning /path.to/properties.file [default proxy value]
# Return 0 if the JCS instance is running, > 0 otherwise with an value in errorValue
# $1 file 
# return value
#	0 success
#	1 file argument missing
#   2 property file provided but does not exist/cannot be found.
#   3 various cURL errors, see errorValue for text of full error
#
function jcsIsRunning () {
	local propertyfile=$1
	local defaultProxyvalue=""
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
		echo "Usage jcsIsRunning property.file [default proxy]"
		return 1
	fi
	if [[ $# -gt 1 ]]; then
		defaultProxyvalue=$2
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
	# It appears we need a proxy for accessing the end point
	# check that one is assigned
	#
	if [[ -n "$https_proxy" ]] ; then
		if [[ "$debug" = "1" ]]; then
			echo "Using https_proxy = $https_proxy"
		fi
	elif  [[ ! -n "$https_proxy" && -n "$defaultProxyvalue" ]] ; then 
		if [[ "$debug" = "1" ]]; then
			echo "https_proxy not set and default value of '$defaultProxyvalue' found. Using default https_proxy=$defaultProxyvalue"
		fi
		https_proxy=$defaultProxyvalue
	elif  [[ ! -n "$http_proxy" ]] ; then 
		# no proxy try and get one from properties
		getProperty https_proxy $propertyFile
		if [[ -n "$resultValue" ]]; then
			echo "Found proxy value in properties file, using https_proxy=$resultValue"
			https_proxy=$resultValue
			fi
	else
		if [[ "$debug" = "1" ]]; then
			echo "https_proxy not set, no default provided and not found in $propertyfile, not using https_proxy"
		fi
		https_proxy=""
	fi

	#
	# Set up environment
	# 
	exportProperties $propertyfile

	
	#if [[ -n "$https_proxy" ]]; then
	#	echo "Using https_proxy $https_proxy"
	#fi
	#
	# Now run the test
	#
	curlCommand="curl -k -i -X GET -u ${opcUsername}:${opcPassword} -H X-ID-TENANT-NAME:${identityDomain}  ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName}"
	#curl -k -i -X GET -u al.saganich@oracle.com:Welc0me1 -H X-ID-TENANT-NAME:docsjcs3 https://jcs.emea.oraclecloud.com/paas/service/jcs/api/v1.1/instances/docsjcs3/JCS
	#echo $curlCommand
	if [[ "$debug" = "1" ]]; then
		echo "Executing curl request '$curlCommand'"
	fi

	$curlCommand > fourohfour.out 2>&1
	fourohfour=`grep 404 fourohfour.out`
	#echo fourohfour=$fourohfour
	rm -f fourohfour.out
	if [[  -n "$fourohfour" ]]; then
		echo "End point ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${JCSServiceName}/${JCSServiceName} does not appear to exist ($fourohfour)"
		return 1
	fi

	curlResponse=$($curlCommand) 2>&1
	status=`echo $curlResponse |cut -d',' -f 5| cut -d':' -f 2 |tr -d '\"' | sed -e 's/^[ \t]*//'`
	#echo "status=$status"
	#status=`echo $curlResponse | cut -d':' -f 5  |tr -d '\"'| sed -e 's/^[ \t]*//'`
	#echo "JCS end point ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName} status = ${status}"
	completeStatus="Running"
	#echo 
	#echo 
	if [[ "$status" = "$completeStatus" ]] ; then
		#echo "Exists and is running"
		echo "End point ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName} exists and is running."
		return 0
	else
		#echo "Exists but not running"
		echo "End point ${JCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/${JCSServiceName} exists but is not running. Status=${status}."
		return 1
	fi
	
	return 1 # how did we get here?
}

#
# datebaseIsRunning /path.to/properties.file [default proxy value]
# Return 0 if the database is running, > 0 otherwise with an value in errorValue
# $1 file 
# return value
#	0 success
#	1 file argument missing
#   2 property file provided but does not exist/cannot be found.
#   3 various cURL errors, see errorValue for text of full error
#   4 missing certificate file
#
function databaseIsRunning () {
	local propertyfile=$1
	local defaultProxyvalue=""
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
		echo "Usage databaseIsRunning property.file "
		return 1
	fi
	if [[ $# -gt 1 ]]; then
		defaultProxyvalue=$2
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
	# It appears we need a proxy for accessing the db end point
	# check that one is assigned
	#
	if  [[ ! -n "$https_proxy" && -n "$defaultProxyvalue" ]] ; then 
		if [[ "$debug" = "1" ]]; then
			echo "https_proxy not set and default value of '$defaultProxyvalue' found. Using default https_proxy=$defaultProxyvalue"
		fi
		https_proxy=$defaultProxyvalue
	elif  [[ ! -n "$http_proxy" ]] ; then 
		# no proxy try and get one from properties
		#echo "getProperty https_proxy $propertyfile"
		getProperty https_proxy $propertyfile
		if [[ -n "$resultValue" ]]; then
			echo "Found proxy value in properties file, using https_proxy=$resultValue"
			https_proxy=$resultValue
			fi
	else
		if [[ "$debug" = "1" ]]; then
			echo "https_proxy not set, no default provided and not found in $propertyfile, not using https_proxy"
		fi
		https_proxy=""
	fi

	#echo "getProperty UTILITY_DIR $propertyfile"
	getProperty UTILITY_DIR $propertyfile
	local utilDir=$resultValue
	
	local CertFile="${utilDir}/../common/cacert.pem"

	
	if [[ ! -f "$CertFile" ]]; then
	   	errorValue="Error: required $CertFile file not found"
		echo $errorValue
		return 3
	fi

	#
	# Set up environment
	# 
	exportProperties $propertyfile

	#
	# Now do the test
	#
	curlCommand="curl -s --include --request GET --cacert $CertFile --user ${opcUsername}:${opcPassword} --header "X-ID-TENANT-NAME:${identityDomain}" ${DBCSEndpoint}/paas/service/dbcs/api/v1.1/instances/${identityDomain}/${DBCSServiceName}"
	
	if [[ "$debug" = "1" ]]; then
		echo "executing '$curlCommand'"
	fi
	
	curlResponse=$($curlCommand)
	#hack
	$curlCommand > fourohfour.out 2>&1
	fourohfour=`grep 404 fourohfour.out`
	echo fourohfour=$fourohfour
	rm -f fourohfour.out
	if [[  -n "$fourohfour" ]]; then
		echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} does not appear to exist ($fourohfour)"
		return 1
	fi
	#echo $curlResponse |cut -d',' -f 4 |cut -d':' -f 2  |tr -d '\"' |tr -d '[[:space:]]' #| tr -d ',\"'
	#echo curlResponse=$curlResponse
	#status=`echo $curlResponse | cut -d':' -f 2 | tr -d '[[:space:]]' #| tr -d ',\"'`
	status=`echo $curlResponse |cut -d',' -f 4 |cut -d':' -f 2  |tr -d '\"' |tr -d '[[:space:]]' #| tr -d ',\"'`
	echo "DB end point ${dbsendpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain} status = ${status}"
	if [[ "$status" = "Running" ]] ; then
		echo "End point ${DBCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identityDomain}/$DBCSServiceName exists and is running."
		return 0
	else
		echo "End point ${DBCSEndpoint}/paas/service/jcs/api/v1.1/instances/${identitydomain}/$DBCSServiceName exists but is not running. Status=${status}."
		return 1
	fi

	
	
	return 1 # how did we get here?
}

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
	#echo `$curlCOMMAND`
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
	setProperty JCSHost $wls_ip $propertyfile

	setProperty otd_ip $otd_ip $propertyfile
	setProperty OTDHost $otd_ip $propertyfile


	#
	# Now the database, which requires a cert
	#

	#
	# First validate that we have a cert 
	# 
	local certFile="${UTILITY_DIR}/../common/cacert.pem"
	
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
	setProperty DBCSHost $db_ip $propertyfile
	
	echo WLS ADMIN URL: ${wls_admin_url}
	echo OTD ADMIN URL: ${otd_admin_url}
	echo DB ADDRESS: ${db_address}
	echo DB CONNECT: ${db_connect}
	echo WLS ADMIN IP: ${wls_ip}
	echo OTD IP: ${otd_ip}
	echo DB IP: ${db_ip}
	return 0
}

#
#
# addToEtcHosts hostname ip rootpwd
# For example:
# addToEtcHosts jcshost 140.86.39.90 welcome1
# Returns 
#	0 on success
#	1 on already exists 
#
function addToEtcHosts() {

	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	if [[ $# -ne 3 ]]; then
		errorValue="Error: Usage: addToEtcHost hostname ip rootPWD"
		echo "$errorValue"
		return 1
	fi

	
	local hostName=$1
	local ipAddress=$2
	local rootPwd=$3
	if [[ "$debug" = "1" ]]; then
		echo "Attempting to add '$hostName' with ip '$ipAddress' to /etc/hosts using rootpwd '$rootPwd'"
	fi

	#
	# Look for it already there, do nothing if present
	#
	match_count=`grep -i $hostName /etc/hosts | wc -l`
	if [[ "$match_count" -gt 0 ]]; then
		if [[ "$debug" = "1" ]]; then
			echo "Found $matchcount instances of $hostName in /etc/hosts nothing to do, exiting."
		fi
                echo "Warning: Unexpectedly found ${hostname} in /etc/hosts!"
                echo "         could not add $ipAddress $hostName"
		return 1
	fi
	if [[ "$debug" = "1" ]]; then
		echo "Found $matchcount instances of $hostName in /etc/hosts adding entry."
	fi

	#
	# add it
	#
	if [[ "$debug" = "1" ]]; then
		echo "Found $matchcount instances of $hostname in /etc/hosts adding entry."
		echo "Adding ${ipAddress} ${hostName} to /etc/hosts"
	fi

	echo $rootPwd | su root -c "echo \"$ipAddress $hostName\" >> /etc/hosts" > /dev/null 2>&1

	return 0
}
