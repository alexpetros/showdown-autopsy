#!/bin/bash

set -euo pipefail

while read line
do
  # Skip blank lines
  if [[ -z $line ]]; then continue; fi

  log_url=$line".log"
  filename=$(echo $log_url | awk -F '/' '{print $NF}')
  curl $log_url > logs/$filename 2> /dev/null
  echo Downloaded $log_url
  sleep 1
done
