#!/bin/bash

# colours
BOLD='\033[1;32m'
NC='\033[0m'

# time stamp
STAMP=$BOLD[$(date +"%T")]$NC
DATE=`date +%Y-%m-%d`
RAW_DATE=`date +%Y-%m-%d`
RAW_HOURS=`date +%T`
RAW_ZONE=`date +%z`

# regex
FIND_PACKAGES='<ul class="bullet-free collaborated-packages">(.*)<ul class="bullet-free starred-packages">'
FIND_LINK='(\/package\/(.*))"'

# program
echo "$STAMP Fetching data blob of user information..."

BLOB=$(curl --silent https://www.npmjs.com/~nickzuber)

echo "$STAMP Sifting through response for packages..."

if [[ $BLOB =~ $FIND_PACKAGES ]]; then
  for word in ${BASH_REMATCH[1]}; do
    if [[ $word =~ $FIND_LINK ]]; then
      echo ${BASH_REMATCH[1]}
    fi
  done
else
  echo "$STAMP ERROR: Unable to find any packages from response."
fi
