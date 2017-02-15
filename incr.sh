#!/bin/bash

SCRIPT_NAME=`basename "$0"`
SOURCE_DIR="$1"

pushd "$SOURCE_DIR" 1>/dev/null

FILE_LIST=$(ls -1 | sort -n -r)

for FILE_NAME in ${FILE_LIST}; do
	FILE_NAME_OLD="${FILE_NAME%%.*}"
	EXTENSION="${FILE_NAME#*.}"
	
	FILE_NAME_NEW=$FILE_NAME_OLD
	let FILE_NAME_NEW++

	if [ -f "$FILE_NAME_NEW.$EXTENSION" ]; then
		echo "$SCRIPT_NAME:$LINENO: file exists $FILE_NAME_NEW.$EXTENSION"
	else
		mv "$FILE_NAME" "$FILE_NAME_NEW.$EXTENSION"
	fi
done

popd 1>/dev/null

exit 0
