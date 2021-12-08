#!/bin/bash

## ---------------------------
## Name:  download-apk.sh
## Author: Josias Bruderer
## Date: 06.12.2021
##
## Description: This script installs and downloads an apk file
## ---------------------------
## Usage:
## ./download-apk.sh app.namespace
## ./download-apk.sh ch.protonmail.android
## ---------------------------

if [ "$1" == "" ]; then
	echo "app name missing"
	exit 1
else
	if [ "$(adb devices | grep "device$")" == "" ]; then
		echo "adb not connected"
		exit 1
	fi

	echo "start downloading $1"
fi

mkdir -p debug/$1
rm debug/$1/* 2> /dev/null

adb shell screencap -p > debug/$1/01.jpg

if [ "$(adb shell dumpsys power | grep mWakefulness= | grep -oE '(Awake|Dozing)')" == "Dozing" ] ; then
  adb shell input keyevent 26 # unlock phone
else
  adb shell input keyevent 26 # lock phone
  sleep 1
  adb shell input keyevent 26 # unlock phone
fi

sleep 2

adb shell screencap -p > debug/$1/02.jpg

newinstall=0

if [ "$(adb shell pm list packages $1)" == "package:$1" ]; then
	echo "installation found for $1"
else
	newinstall=1
	echo "start installing $1"

	eval "adb shell am start -a android.intent.action.VIEW -d 'market://details?id=$1'"

	adb shell screencap -p > debug/$1/03.jpg
	sleep 2
	adb shell input tap 540 750 # setting for oneplus 3T

	adb shell screencap -p > debug/$1/04.jpg
	sleep 10
	adb shell screencap -p > debug/$1/05.jpg
	sleep 10
	adb shell screencap -p > debug/$1/06.jpg
	sleep 10
	adb shell screencap -p > debug/$1/07.jpg

	if [ "$(adb shell pm list packages $1)" == "package:$1" ]; then
      echo "successfully installed $1"
	else
	  echo "error installing $1 --> try alternative position 1"
	  eval "adb shell am start -a android.intent.action.VIEW -d 'market://details?id=$1'"
	  sleep 2
	  adb shell input tap 540 840 # alternative setting 1 for oneplus 3T

      adb shell screencap -p > debug/$1/08.jpg
      sleep 30
      adb shell screencap -p > debug/$1/09.jpg

      if [ "$(adb shell pm list packages $1)" == "package:$1" ]; then
        echo "successfully installed $1"
	  else
        echo "error installing $1 --> try alternative position 2"
        eval "adb shell am start -a android.intent.action.VIEW -d 'market://details?id=$1'"
        sleep 2
        adb shell input tap 780 750 # alternative setting 1 for oneplus 3T

        adb shell screencap -p > debug/$1/10.jpg
        sleep 30
        adb shell screencap -p > debug/$1/11.jpg

        if [ "$(adb shell pm list packages $1)" == "package:$1" ]; then
          echo "successfully installed $1"
        else
          echo "error installing $1"
          echo "error installing $1" >> debug/errors.log
        fi
      fi
	fi
fi

mkdir -p apps/$1
rm apps/$1/* 2> /dev/null

adb shell pm path $1 | grep -oE '(\/data.*)' | while read p; do
	adb pull $p apps/$1/
done

echo "successfully downloaded $1"
echo "successfully downloaded $1" >> debug/success.log

if [ $newinstall -eq 1 ]; then
	sleep 5
	adb shell screencap -p > debug/$1/12.jpg
	adb reboot
	sleep 60
	adb shell screencap -p > debug/$1/13.jpg
fi

echo "done"
