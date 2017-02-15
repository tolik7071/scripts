#!/bin/bash
# Finds the specific string in files of the current dir
# $1 - string to search

SEARCH_STRING=$1

OLD_IFS=$IFS
IFS=$'\n'

#ALL_FILES=$(ls -1)
ALL_FILES=$(find . -type f)
for CURRENT_FILE in $ALL_FILES
do
	if [ -f $CURRETN_FILE ];
	then
		OUTPUT_STRING=$(cat $CURRENT_FILE | egrep "$SEARCH_STRING")
		if [ ${#OUTPUT_STRING} -ge 1 ];
		then
            printf "$CURRENT_FILE -> %.50s\n" "$OUTPUT_STRING"
		fi
	fi
done

IFS=$OLD_IFS

exit 0
