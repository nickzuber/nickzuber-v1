#!/bin/bash

bold='\033[90m'
green='\033[0;32m'
red='\033[0;31m'
reset='\033[0m'
stamp=[$bold$(date +"%T")$reset]
cur_date=`date +%Y-%m-%d`

find_packages='<ul class="bullet-free collaborated-packages">(.*)<ul class="bullet-free starred-packages">'
find_link='(\/package\/(.*))"'
download_count='\"downloads\"\:([0-9]+)'

count=0
total_download_count=0

echo "$stamp Pinging npm for data response containing user information."

response=$(curl --silent https://www.npmjs.com/~nickzuber)

echo "$stamp Sifting through response for packages."

if [[ $response =~ $find_packages ]]; then
  echo "$stamp Found the following packages:"
  for word in ${BASH_REMATCH[1]}; do
    if [[ $word =~ $find_link ]]; then
      echo "$stamp └─ ${BASH_REMATCH[2]} \t2015-11-12 ╪ $cur_date"
      package_data=$(curl --silent https://api.npmjs.org/downloads/range/2015-11-12:$cur_date/${BASH_REMATCH[2]} \
                | sed -e 's/[{}]/''/g' \
                | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}')
      for data in $package_data; do
        if [[ $data =~ $download_count ]]; then
          total_download_count=$(( total_download_count + ${BASH_REMATCH[1]} ))
        fi
      done
      (( count++ ))
    fi
  done
else
  echo "$stamp$red Error: Unable to find any packages from response. Probably no internet connection.$reset"
  exit 1
fi

echo "$stamp Counted $green$total_download_count$reset downloads from $count packages."

echo "$stamp Updating development config file."
eval "sed -i '' -e 's/npm_stats: [0-9]*/npm_stats: $total_download_count/' _config.yml"

echo "$stamp Updating production config files."
eval "sed -i '' -e 's/npm_stats: [0-9]*/npm_stats: $total_download_count/' _config_dev.yml"

echo "$stamp$green Successfully update the download stats!$reset"
