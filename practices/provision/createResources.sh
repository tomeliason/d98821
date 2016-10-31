#/bin/bash
#
# Create a set of domain DB resources based on the elements in the userlist below
#

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR/createDB.sh
source $CURRENT_DIR/checkDB.sh

#
# Read the list of usernames etc to be processed
#
source $CURRENT_DIR/userlist.properties



echo "Creating a set of database resources"
echo "Note this script will use the common SSH Master key set ~/.ssh/id_rsa*"
echo "And it will take a long and and use every resource known to man"
echo "Are you really sure?"


while true ; do
	read -p "Are you sure you want to create resources? Y/n [N]" answer
	# default is no
	if [[ -z "$answer" ]]; then
		answer="N"
	fi
	case $answer in
	   [yY]* )
		break ;;	
	   [nN]* ) 
		echo "Abort Will Robinson!"
		return 0;
		exit ;;
	   * )  echo "Want to try that again? I dont get '$answer'"; 
		continue ;;
	esac
done
while true ; do
	read -p "Are you REALLY you want to create resources? Y/n [N]" answer
	# default is no
	if [[ -z "$answer" ]]; then
		answer="N"
	fi
	case $answer in
	   [yY]* )
		echo "If you insist, but I have a pain in all the diodes on my left side!"
		break ;;	
	   [nN]* ) 
		echo "Thank the lord a reasonable man!"
		return 0;
		exit ;;
	   * )  echo "Huh? $answer'"; 
		continue ;;
	esac
done


echo "Processing $count elements"
# use for loop read all nameservers
for (( i=0; i<${count}; i++ ));do
	# echo "Processing raw entry ${userlist[$i]}"
	iddomain=`echo ${userlist[$i]} | cut -d: -f1 `
	uname=`echo ${userlist[$i]} | cut -d: -f2 `
	password=`echo ${userlist[$i]} | cut -d: -f3 `
	#echo "ID:'$iddomain' uname:'$uname' pwd:'$password'"
	echo "createDB $iddomain $uname $password"
	createDB $iddomain $uname $password
done

echo "All database requests submitted, note that each database request gates its associated JCS request"
echo "Will now wait until the first request in the list is complete and process, its request, then will wait on each subsequent request, which can take literally hours"

echo "Checking for DB Running on each instance"
echo "DB Running indicates the createJCS step can be executed"


for (( i=0; i<${count}; i++ ));do
	# echo "Processing raw entry ${userlist[$i]}"
	iddomain=`echo ${userlist[$i]} | cut -d: -f1 `
	uname=`echo ${userlist[$i]} | cut -d: -f2 `
	password=`echo ${userlist[$i]} | cut -d: -f3 `
	#echo "ID:'$iddomain' uname:'$uname' pwd:'$password'"
	echo "checkDBExists $iddomain $uname $password"
	
	#
	# This loop should also check how often it looped waiting
	# and then bail on the DB instance after a certain amount of loops (4 or 5x 5 minutes?)
	#
	while true ; do

		checkDBExists $iddomain $uname $password
		dbExists=$?
		if [[ $dbExists -eq 0 ]]; then
			echo "Database exists and is running for $iddomain $uname $password submitting request to create JCS instance"
			createJCS $iddomain $uname $password
			break;
		fi
	
		if [[ $dbExists -eq 1 ]]; then
			echo "Database exists but is not yet running for $iddomain $uname $password"
			echo "Sleeping for 5 minutes"
			sleep 300
		fi
		#
		# Anything else is bad
		#
		echo "Error checkDBExists returned $dbExists! Check function return values to equate error code with error"
		echo "Cannot continue with this DB instance"
		echo "Associated JCS instance NOT created!"
		break;
	done
done




