#!/bin/#!/usr/bin/env bash

#decrypted="2342q3rkjln;"
#echo "The password:('${decrypted}') has been saved after encryption"
decrypted="@#$^[[1;2S!EASDF"
`keybase decrypt -i file.txt > ${decrypted}`

echo $decrypted
echo "$decrypted"
echo -e "\e[38;5;0;48;5;255m$decrypted\e[0m"
