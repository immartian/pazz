#!/bin/bash

value=`cat data/im@quantalucia.com_binance`
echo "$value"

dbfile='pass.db'
#head $file -n 1 | sed "s/,/\n/g" | awk '{printf("%d %s\n", NR-1, $0)}'

cmd1="sqlite3 database.db"
cmd2="select * from databases"

`sqlite3 $dbfile "UPDATE n SET p = '$value' WHERE u= 'im@quantalucia.com' "`

result=`sqlite3 $dbfile "SELECT p FROM n WHERE u= 'im@quantalucia.com' LIMIT 1" `
final=`keybase decrypt -m "$result"`
echo $final
