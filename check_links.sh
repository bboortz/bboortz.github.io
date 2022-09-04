#!/bin/bash

set -e 
set -u

err_count=0

while read f; do
  echo -ne "** $f  --> "
  resp_code=$( curl -o /dev/null --no-progress-meter -w "%{http_code}\n" $f || echo $?)

  if [ "$resp_code" != "200" ]; then
      let "err_count = err_count + 1"
      echo " *** ERROR ***"
  else
      echo " OK"
  fi
done < <( cat index.md| gawk 'match($0, /* \[(.*)\]\((.*)\)/, a) {print a[2]}')

echo "NUMBER_OF_ERRORS: $err_count"
exit $err_count
