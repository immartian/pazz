#!/bin/bash
#
## @isaac
# The purpose of this tool is to well the simplicity
# and security of Keybase to manage your or your team's passwords easily
##
### Usage: passbase [team name]
##

# 1. check sqlite3 exist or install it
if ! type sqlite3 > /dev/null;  then
	sudo apt install sqlite3 -y
fi

# default as individual, the current user from keybase runtime
kbuser=`keybase whoami`
if [ -z "$kbuser" ]; then
	`run_keybase -g`
	kbuser=`keybase whoami`
fi

type="Private"
teamname=$kbuser
base_path="/keybase/private/${kbuser}/vault/"	#if it's individual

# Or, check if there's arguments from command line, use it as team name if so
if [ ! -z "$1" ]; then
	type="Team"
	teamname=$1
	base_path="/keybase/team/${teamname}/vault/"	#if it's for a team
fi

# check if the db file exists already
dbfile="${base_path}vault.db"
if [ -f "$dbfile" ]; then
    echo "(Using $dbfile)"
else
	echo "(new DB file: $dbfile created)"		#"Using $dbfile ..."
 	`mkdir -p $(dirname $dbfile)`
	`sqlite3 $dbfile "create table n (id INTEGER PRIMARY KEY,u TEXT,p TEXT,s TEXT, t TEXT);"`
fi

# provide a menu for user to choose (create, search... )
dbcmd="sqlite3 database.db"
sqlcmd="select * from databases"
#`sqlite3 $dbfile "UPDATE n SET p = '$encrypted' WHERE u= 'im@quantalucia.com' "`
while :
do
	echo -e "\n===== What to do ? ($type:$teamname)======"
	PS3="Enter a purpose(1-3): "
	select purpose in search create exit
	do
		case $purpose in
			search)
				# search in fuzzy way through user names and services
				read -p 'What to search(user name, service, etc.): ' searchvar

				IFS=$'\n'
				choices=( `sqlite3 $dbfile "SELECT u,s FROM n WHERE u LIKE '%$searchvar%' OR s LIKE '%$searchvar%'"` )
				PS3="Which entry you want to view password with? "
				select answer in "${choices[@]}"; do
				  for item in "${choices[@]}"; do
				    if [[ $item == $answer ]]; then
							IFS='|' read -r -a array <<< "$item"
							uservar="${array[0]}"
							servicevar="${array[1]}"
							result=`sqlite3 $dbfile "SELECT p FROM n WHERE u='$uservar' AND s='$servicevar';"`
							echo -n "... decoding password for ($item)..."
							decrypted=`keybase decrypt -m "$result"`
							#`keybase decrypt -m "$result" -o a.txt`
							echo -n "The password to $item: "
							# there's a problem with this string "@#$^[[1;2S!EASDF" which is not possible to display
							echo -e "\e[38;5;0;48;5;255m${decrypted}\e[0m"
							#printf "%s\n" "$decrypted"
							break 2
				    fi
				  done
				done
				break
				;;
			create)
				# 5.1 Create an new entry
				read -p 'Key(Login name): ' uservar
				read -p 'Service(e.g. Google) ' servicevar
				read -p 'Password/Secret: ' passwordvar
				echo "Wait a moment for encryption... "
				if [ $teamname = $kbuser ]; then
					scope="$kbuser"						#decryptable only by myself
				else
					scope="--team $teamname"	#decryptable to the whole team
				fi
				encrypted=`keybase encrypt $scope -m $passwordvar`
				`sqlite3 $dbfile "INSERT INTO n (u,p,s,t) values ('$uservar', '$encrypted', '$servicevar', datetime('now'))"`
				echo "Password to $uservar|$servicevar saved safely."
				break
				;;
			exit)
				clear
				exit
				;;
		esac
	done
done
