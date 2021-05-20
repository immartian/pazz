#!/bin/bash
#
## @isaac
# The purpose of this tool is to well the simplicity
# and security of Keybase to manage your or your team's passwords easily
##
### Usage: passbase [options]
##
## Options:
##   -h, --help    Display this message.

# 1. check sqlite3 exist or install it
if ! type sqlite3 > /dev/null;  then
	sudo apt install sqlite3 -y
#else
#	echo "...db works"
fi

# default as individual, the current user from keybase runtime
kbuser=`keybase whoami`
PS3="Enter a purpose: "
base_path="/keybase/private/${kbuser}/vault/"	#if it's individual

# Or, check if there's arguments from command line, use it as team name if so
if [ ! -z "$1" ]; then
	teamname=$1
	base_path="/keybase/team/${teamname}/vault/"	#if it's for a team
fi

# check if the db file exists already
dbfile="${base_path}vault.db"
if [ -f "$dbfile" ]; then
    echo "==============================="		#"Using $dbfile ..."
else
	echo "==== new password DB in creation ===="		#"Using $dbfile ..."
 	`mkdir -p $(dirname $dbfile)`
	`sqlite3 $dbfile "create table n (id INTEGER PRIMARY KEY,u TEXT,p TEXT,s TEXT);"`
fi

# provide a menu for user to choose (create, search... )
dbcmd="sqlite3 database.db"
sqlcmd="select * from databases"
#`sqlite3 $dbfile "UPDATE n SET p = '$encrypted' WHERE u= 'im@quantalucia.com' "`
while :
do
	select purpose in search create exit
	do
		case $purpose in
			search)
				# search in fuzzy way through user names and services
				read -p 'What to search(user name, service, etc.): ' searchvar
				result=`sqlite3 $dbfile "SELECT u,s FROM n WHERE u LIKE '%$searchvar%' OR s LIKE '%$searchvar%'" `
				echo $result
				break
				;;
			create)
				# 5.1 Create an new entry
				read -p 'Username: ' uservar
				read -p 'Password: ' passwordvar
				read -p 'Service(e.g. Google) ' servicevar
				encrypted=`keybase encrypt $kbuser -m $passwordvar`
				`sqlite3 $dbfile "INSERT INTO n (u,p,s) values ('$uservar', '$encrypted', '$servicevar')"`
				break
				;;
			*)
			exit
			;;
		esac
	done
done
