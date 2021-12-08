#!/bin/bash

## ---------------------------
## Name:  run.sh
## Author: Josias Bruderer
## Date: 08.12.2021
##
## Description: This script runs the apk-extractor
## ---------------------------
## Usage:
## ./run.sh
##
## You can setup this script as cronjob.
## Note that it will need about 2 minutes per app (if it is already installed on the device, it will be faster)
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
  ./scripts/download-apk.sh "$i"
  cp "apps/$i/" "../frontend/apps/" -r
  cp "debug/$i/" "../frontend/debug/" -r
  yes | cp "debug/errors.log" "../frontend/debug/" -rf
done

# process paid apps
for i in ${paidapps[*]}; do
  ./scripts/download-apk.sh "$i"
  cp "apps/$i/" "../frontend/apps/" -r
  cp "debug/$i/" "../frontend/debug/" -r
  yes | cp "debug/errors.log" "../frontend/debug/" -rf
done

