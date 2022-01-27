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

sleep 5
adb shell screencap -p > debug/initial_before-restart.jpg
yes | cp "debug/initial_before-restart.jpg" "../frontend/debug/" -rf
adb reboot # restart device for a clean state
sleep 60
adb connect $androidDevice
adb shell screencap -p > debug/initial_after-restart.jpg
yes | cp "debug/initial_after-restart.jpg" "../frontend/debug/" -rf
sleep 2

# install updates
adb shell screencap -p > debug/before_updates.jpg
yes | cp "debug/before_updates.jpg" "../frontend/debug/" -rf
eval "adb shell monkey -p com.android.vending 1"
sleep 4
adb shell input tap 950 140 # setting for oneplus 3T
sleep 2
adb shell input tap 400 790 # setting for oneplus 3T
sleep 2
adb shell input tap 260 825 # setting for oneplus 3T
sleep 60
adb shell screencap -p > debug/after_updates.jpg
yes | cp "debug/after_updates.jpg" "../frontend/debug/" -rf
sleep 2
adb shell input keyevent KEYCODE_HOME

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
  yes | cp "debug/success.log" "../frontend/debug/" -rf
done

# process paid apps
for i in ${paidapps[*]}; do
  ./scripts/download-apk.sh "$i"
  cp "apps/$i/" "../frontend/apps/" -r
  cp "debug/$i/" "../frontend/debug/" -r
  yes | cp "debug/errors.log" "../frontend/debug/" -rf
  yes | cp "debug/success.log" "../frontend/debug/" -rf
done

sleep 5

adb shell screencap -p > debug/end.jpg
yes | cp "debug/end.jpg" "../frontend/debug/" -rf
