#!/bin/bash

## ---------------------------
## Name:  cleanup.sh
## Author: Josias Bruderer
## Date: 08.12.2021
##
## Description: This script cleans up apps and debug of apk-extractor
## ---------------------------
## Usage:
## ./cleanup.sh all
## ./cleanup.sh frontend
## ./cleanup.sh backend
## --------------------------

cd "$(dirname "$0")"  # change directory to make sure all relative paths work

if [[ $1 == "" ]]; then
  echo "parameter is requried"
  exit 1
fi

echo start cleaning up $1

if [[ $1 == "frontend" || $1 == "all" ]]; then
  rm -rf ../frontend/apps/*
  rm -rf ../frontend/debug/*
fi

if [[ $1 == "backend" || $1 == "all" ]]; then
  rm -rf apps/*
  rm -rf debug/*
fi
