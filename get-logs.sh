#!/bin/bash
# get-logs.sh - Download a bunch of pokemon showdown battles
# Reads a list of pokemon showdown links from STDIN and downloads them in turn

set -euo pipefail

while read line
do
  # Skip blank lines
  if [[ -z $line ]]; then continue; fi

  log_url=$line".log"
  filename=$(echo $log_url | awk -F '/' '{print $NF}')
  curl $log_url > logs/$filename 2> /dev/null
  echo Downloaded $log_url
  sleep 1 # Let's not DDOS Pokemon Showdown
done
