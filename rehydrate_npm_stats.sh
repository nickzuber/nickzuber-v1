#!/bin/bash

BOLD='\033[1;32m'
NC='\033[0m'

STAMP=$BOLD[$(date +"%T")]$NC
DATE=`date +%Y-%m-%d`
RAW_DATE=`date +%Y-%m-%d`
RAW_HOURS=`date +%T`
RAW_ZONE=`date +%z`

echo "$STAMP Fetching data blob of user information..."

BLOB=$(curl --silent https://www.npmjs.com/~nickzuber)

echo "$STAMP Sifting through response for packages..."

FIND_PACKAGES='collaborated-packages">(.*)</ul>'
echo $BLOB
if [[ $BLOB =~ 'collaborated-packages">(.*)</ul>' ]]; then
  echo "success"
fi
