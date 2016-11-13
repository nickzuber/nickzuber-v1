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
DOWNLOADS='\"downloads\":(.*?)'

# https://api.npmjs.org/downloads/range/2015-11-12:2016-11-16/<package>
# counters and trackers
COUNT=0
DL_COUNT=0

# program
echo "$STAMP Fetching data blob of user information."

BLOB=$(curl --silent https://www.npmjs.com/~nickzuber)

echo "$STAMP Sifting through response for packages."

if [[ $BLOB =~ $FIND_PACKAGES ]]; then
  for word in ${BASH_REMATCH[1]}; do
    if [[ $word =~ $FIND_LINK ]]; then
      PACKAGE=$(curl --silent https://api.npmjs.org/downloads/range/2015-11-12:$RAW_DATE/${BASH_REMATCH[2]} \
                | sed -e 's/[{}]/''/g' \
                | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}')
      for data in $PACKAGE; do
        if [[ $data =~ \"downloads\"\:([0-9]+) ]]; then
          DL_COUNT=$(( DL_COUNT + ${BASH_REMATCH[1]} ))
        fi
      done
      (( COUNT++ ))
    fi
  done
else
  echo "$STAMP ERROR: Unable to find any packages from response."
fi

echo "$STAMP Found $COUNT packages."
echo "$STAMP Total downloads counted was $DL_COUNT."
