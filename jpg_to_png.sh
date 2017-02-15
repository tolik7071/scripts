#!/bin/bash
# $1 - source dir

SCRIPT_NAME=`basename "$0"`
SOURCE_DIR=$1
START_DIR=`dirname "$0"`

pushd "${SOURCE_DIR}" 1>/dev/null

OLD_IFS=$IFS
IFS=$'\n'

FILE_LIST=$(find . -name "*.jpg")

for FILE_NAME in ${FILE_LIST}; do
	FILE_NAME_ORIGINAL=$(basename $FILE_NAME)
	FILE_NAME_ONLY="${FILE_NAME_ORIGINAL%.*}"
	"$START_DIR/ImageConverter" "$FILE_NAME_ORIGINAL" "$FILE_NAME_ONLY.png"
done

IFS=$OLD_IFS

popd 1>/dev/null

exit 0
