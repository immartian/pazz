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


# 2.select it's for private use or team
kbuser=`keybase whoami`
PS3="Enter a purpose: "

select purpose in private team
do
	case $purpose in
		private)
			base_path="/keybase/private/${kbuser}/vault/"	#if it's individual
			break
			;;
		team)
			teamname="quantalucia"
			base_path="/keybase/team/${teamname}/vault/"	#if it's for a team
			break
			;;
		*)
			exit
			;;
	esac
done

# 3. check if the db file exists already
dbfile="${base_path}pass.db"
if [ -f "$dbfile" ]; then
    echo "==============================="		#"Using $dbfile ..."
else
 	`mkdir -p $(dirname $dbfile)`
	`sqlite3 $dbfile "create table n (id INTEGER PRIMARY KEY,u TEXT,p TEXT,s TEXT);"`
fi

read -p 'Username: ' uservar
read -p 'Password: ' passwordvar
read -p 'Service(e.g. Google) ' servicevar

encrypted=`keybase encrypt $kbuser -m $passwordvar`
#echo "$encrypted"

dbcmd="sqlite3 database.db"
sqlcmd="select * from databases"

#`sqlite3 $dbfile "UPDATE n SET p = '$encrypted' WHERE u= 'im@quantalucia.com' "`
`sqlite3 $dbfile "INSERT INTO n (u,p,s) values ('$uservar', '$encrypted', '$servicevar')"`

result=`sqlite3 $dbfile "SELECT p FROM n WHERE u= '$uservar' LIMIT 1" `
decrypted=`keybase decrypt -m "$result"`
echo "The password:('${decrypted}') has been saved after encryption"