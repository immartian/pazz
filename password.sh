#!/bin/bash

#$file='pass.csv'
#head $file -n 1 | sed "s/,/\n/g" | awk '{printf("%d %s\n", NR-1, $0)}'

while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
do
  echo "Username-$rec_column1"
  echo "Service: $rec_column2"
  echo "Password: $rec_column3"
  echo "Created at: $rec_column4"
  echo ""
done < <(tail -n +2 pass.csv)
