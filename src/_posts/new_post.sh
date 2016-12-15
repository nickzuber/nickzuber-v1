#!/bin/bash

BOLD='\033[1;32m'
NC='\033[0m'

STAMP=$BOLD[$(date +"%T")]$NC
DATE=`date +%Y-%m-%d`
RAW_DATE=`date +%Y-%m-%d`
RAW_HOURS=`date +%T`
RAW_ZONE=`date +%z`

# Checking for cli arguments

if [[ $1 == "" ]]; then
	echo "$STAMP Missing argument; don't forget to include the name of the post."
	echo "$STAMP Aborting process."
	echo "$STAMP Use case:"
	echo "$STAMP \`sh ./new_post \"Title of Post\"\`"
	exit 0
fi

echo "$STAMP Preparing to create "$1" as a new post..."

# Checking directory

if [[ ${PWD##*/} != '_posts' ]];then
	echo "$STAMP You must be in the posts directory in your jekyll site to run this command."
	echo "$STAMP Aborting process."
	exit 0
fi

echo "$STAMP Inside of a valid directory, continuing without errors."

# Create post slug

echo "$STAMP Creating post slug..."

TITLE_SLUG=""
POST_ARRAY=($1)

for word in "${POST_ARRAY[@]}"; do
	if [[ ! -z $TITLE_SLUG ]]; then
		TITLE_SLUG="$TITLE_SLUG-$word"
	else
		TITLE_SLUG="$word"
	fi
done

TITLE_SLUG="$(tr [A-Z] [a-z] <<< "$TITLE_SLUG")"
YAML_DATE="$RAW_DATE $RAW_HOURS $RAW_ZONE"

echo "$STAMP Slug was created, continuing without errors."

LAYOUT="---\nlayout: post\ntitle: \"$1\"\ndate: $YAML_DATE\npermalink: blog/$TITLE_SLUG\nuse_math: true\n---"

echo "$STAMP New post draft created successfully!"

# Creating file

FILE_NAME="$DATE-$TITLE_SLUG"

echo $LAYOUT > "./$FILE_NAME.md"
