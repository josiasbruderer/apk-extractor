#!/bin/bash

## ---------------------------
## Name:  uninstall_via_adb.sh
## Author: Josias Bruderer
## Date: 08.12.2021
##
## Description: Uninstall apps via adb
## ---------------------------
## Usage:
## ./uninstall_via_adb.sh
## --------------------------

cd "$(dirname "$0")"  # change directory to make sure all relative paths work
. config/default.config      # source config file

echo Connecting $androidDevice
adb connect $androidDevice

# prepare free apps
i=0
freeapps=()
while IFS="" read -r p || [ -n "$p" ]
do
  freeapps[i]=$p
  i=$i+1
done < config/free-apps.txt

# prepare paid apps
i=0
paidapps=()
while IFS="" read -r p || [ -n "$p" ]
do
  paidapps[i]=$p
  i=$i+1
done < config/paid-apps.txt

# process free apps
for i in ${freeapps[*]}; do
  adb uninstall "$i"
done

# process paid apps
for i in ${paidapps[*]}; do
  adb uninstall "$i"
done

sleep 5
adb reboot
sleep 60

echo "done"
