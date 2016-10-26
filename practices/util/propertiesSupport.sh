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
# getProperty 
# $1 property
# $2 file 
# return value
#	0 success
#	1 key argument missing
#	2 file argument missing
#	3 file argument present but file not found
#   4 key is not unique
# returns result in variable resultValue
# returns error in variable errorValue on error
#
function getProperty() {
    
   if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
   fi

   local file=$2
   local key=$1
   resultValue=""
   errorValue=""
   local match_count
   local key_portion=""
   local value_portion=""

    if [[ "X" = "X$key" ]]; then
        errorValue="Error: Missing property key"
        echo "Missing property key"
        echo "Usage getProperty key properties file"
        if [[ "$debug" = "1" ]]; then echo "no key provided, returning 1"; fi
		return 1
    fi
    if [[ "X" = "X$file" ]]; then
        errorValue="Error: Missing property file"
        echo "Missing property file"
        echo "Usage getProperty key properties file" 
        if [[ "$debug" = "1" ]]; then echo "no file provided, returning 1"; fi
		return 2
    fi


	#
	# have two arguments
	# see if file exists
	if [ ! -f $file ]; then
       echo "Property file '$file' not found" 
       errorValue="Error: Property file '$file' not found"

       return 3
	fi

	#
	# check if the key matches multiple lines
	# Note that we can't use grep on the file as we only care about those things on the left
	# side of the equals. 
	#match_count=`grep -i $key $file | wc -l`
	#echo "match_count = $match_count"
	match_count=0
	
	local filename="$file"
	local match_line=""
    while read -r line;	do
		# Skip comments
		if [[ ${line:0:1} = "#" ]]; then
			if [[ "$debug" = "1" ]]; then
				echo "Skipping comment '$line'"
			fi
			continue
		fi

		#
		# Skip lines w/o an equals
		#

		if [[ "$line" != *"="* ]]; then
			if [[ "$debug" = "1" ]]; then
				echo "Skipping line, not key=value '$line'"
			fi
			continue
		fi
		#
		# use cut to get the key portion of the line
		# we don't care of the value portion contains the key
		#
		lineKey=`echo $line|cut -d'=' -f 1`
		if [[ "$debug" = "1" ]]; then
			echo "Processing $line"
			echo "Checking if '$1' is in '$lineKey'"
		fi
		if [[ "$lineKey" = "$key" ]]; then
			match_count=$[$match_count +1]
			match_line=$line # save the matched line for later processing
		fi
	done < "$file"	

	if [[ "$match_count" -gt 1 ]]; then
		echo "Error found $key multiple times in $file"
		errorValue="Error: found '$key' multiple times in '$file'."
		return 5
	fi

	if [[ "$debug" = "1" ]]; then
		echo "Expecting match, using match line '$match_line'"
	fi


	if [[ "$match_line" == "" ]]; then
		if [[ "$debug" = "1" ]]; then
			echo "Not matching lines"
		fi
		
		resultValue=""
		return 0
	fi

	#
	# If we are here we there are no dups
	# 
	# Now parse the file getting the left and right portions of the key
	# 
	local key_portion=`echo $match_line| cut -f1 -d'='`
	local value_portion=`echo $match_line| cut -f2 -d'='`
	
	if [[ "$debug" = "1" ]]; then
		echo "key_portion = $key_portion"
		echo "value_portion = $value_portion"
	fi
	if [[ "X" = "$value_portion" ]]; then
		#not found
		errorValue="Warning: Did not find '$key' in '$file'."
		return 0
	fi

	#
	# check if the key is an exact match.
	# might be a partial match
	#
	if [[ "$key" != "$key_portion" ]]; then
		echo "Key is not unique, expected $key, got '$key_portion' "
		errorValue="Error: found '$key' not unique '$file'."
		return 4
	fi

	#
	# in theory whatever is in valuePortion is the right stuff! 
	# but trim off any comments and white space
	# 
	resultValue=`echo $value_portion|cut -d'#' -f 1`
	resultValue="$(echo -e "${resultValue}" | tr -d '[[:space:]]')"
   
	if [[ "$debug" = "1" ]]; then
		echo "Returning $resultValue for result, status 0"
	fi
	return 0

}

#
# support function
#
function stringContain() { [ -z "${2##*$1*}" ]; }


#
# setProperty 
# $1 property
# $2 value
# $3 file 
# return value
#	0 success
#   1 Missing argument
# returns result in variable resultValue
# Returns error, or warning in errorValue if an error occurs
#
function setProperty() {
    
	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '$@'"
		echo
	fi

	local key=$1
	local keyvalue=$2
	local file=$3
	local matchCount
	resultValue=""
	errorValue=""

	if [[ $# -ne 3 ]]; then
		errorValue="Error: Missing key or property file.  ${FUNCNAME} '$@'"
		return 1
	fi

	if [ ! -f $file ]; then
		if [[ "$debug" = "1" ]]; then
			echo "File $file not found, creating."
		fi
		errorValue="Warning: Property file '$file' not found"
		echo "#" > $file
		echo "# Properties file, created by setProperty function" >> $file
		echo "# Do not edit by hand" >> $file
		echo "#" >> $file
		echo "$key=$keyvalue # added by setProperty" >> $file
		if [[ "$debug" = "1" ]]; then
			echo "Created new properties file."
			cat $file
		fi
		return 0
   fi

	#
	# File found, check if contains value a
	#
	matchCount=`grep -i $key $file | wc -l`
	if [[ "$debug" = "1" ]]; then
		echo "Checking for existing value, match count = $matchCount"
	fi
	if [[ "$matchCount" -gt 0 ]]; then
		#
		# found rewrite the file without the value
		#
		local newFile=${file}.`date +%Y.%m.%d.%H.%M.%S.%ms`
		echo "" > $newFile
		#
		#
		local filename="$file"
		while read -r line
		do
		
			if [[ ${line:0:1} = "#" ]]; then
				
				echo "$line" >> $newFile
				continue
			fi
			#
			# use cut to get the key portion of the line
			# we don't care of the value portion contains the key
			#
			lineKey=`echo $line|cut -d'=' -f 1`
			if [[ "$debug" = "1" ]]; then
				echo "Processing $line"
				echo "Checking if '$1' is in '$lineKey'"
			fi
			
			# [ -z "${string##*$reqsubstr*}" ]
			if [[ ! -z "${lineKey##*$key*}" ]] ;then
				#
				# add other lines to file
				#
				echo "$line" >> $newFile
			fi
		done < "$filename"	

		#
		# Add new value to file
		# 
		echo "$key=$keyvalue # added by setProperty" >> $newFile
		mv -f $newFile $file
	else
		#
		# not found, append it to the end
		#
		echo "$key=$keyvalue # added by setProperty" >> $file	
	fi

	return 0
} 


#
# exportProperties 
# Take an property file and generate and export a set of variables based on those in a property file
#
# $1 file 
# return value
#	0 success
#   1 Missing argument
#	2 properties file not found
# 
# Returns error, or warning in errorValue if an error occurs
#
function exportProperties() {
    
	if [[ "$debug" = "1" ]]; then
		echo "Function name:  ${FUNCNAME}"
		echo "The number of positional parameter : $#"
		echo "All parameters or arguments passed to the function: '($@)'"
		echo
	fi

	local file=$1
	if [[ $# -ne 1 ]]; then
		errorValue="Error: Missing property file.  ${FUNCNAME} '($@)'"
		return 1
	fi

	if [ ! -f $file ]; then
		if [[ "$debug" = "1" ]]; then
			echo "File $file not found."
		fi
		errorValue="Warning: Property file '$file' not found"
		return 1;
	fi

	local filename="$file"
	local exportline=""
	local exportlineTrimmed=""
	local newFilename=${filename}.`date +%Y.%m.%d.%H.%M.%S.%ms`
	
	echo "#generated export file" > $newFilename
	while read -r line
	do
		# Ignore comments
		if [[ ${line:0:1} = "#" ]]; then
			if [[ "$debug" = "1" ]]; then
				echo "Skipping comment '$line'."
			fi
			continue
		fi
		if [[ $(fgrep -ix "export" <<< ${line:0:6}) ]]; then
			if [[ "$debug" = "1" ]]; then
				echo "Skipping comment '$line' starts with export"
			fi
			continue
		fi

		if [[ "$debug" = "1" ]]; then
			echo "Processing '$line'."
		fi
		
		#
		# discard portion after#
		#
		exportline=`echo $line|cut -d'#' -f 1`
		if [[ "$debug" = "1" ]]; then
			echo "export $exportline"
		fi
		#
		# Trim trailing space
		exportline="$(echo -e "${exportline}" | tr -d '[[:space:]]')"
		if [[ ${#exportline} -eq 0 ]]; then
			if [[ "$debug" = "1" ]]; then
				echo "Skipping zero length lines after trimming whitespace"
			fi
			continue
		fi
		#echo "export '$exportline'"
		echo "export $exportline " >> $newFilename
		
	done < "$filename"	

	
	if [[ "$debug" = "1" ]]; then
		echo "Generated property export file"
		cat $newFilename
	fi
	source $newFilename
	rm -f $newFilename
	return 0	
}
