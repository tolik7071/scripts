#!/bin/bash
# $1 - working copy folder

SOURCE_DIR=$1
DESCRIPTION_STRING=$2
SCRIPT_NAME=`basename "$0"`

pushd "$SOURCE_DIR" 1>/dev/null

if [ "$DESCRIPTION_STRING" = "" ];
then
	echo "$SCRIPT_NAME: please use a non-empty description"
	exit 1
fi

svn info &>/dev/null
if [ $? -ne 0 ];
then
	echo "$SCRIPT_NAME: `pwd` is not a working copy"
	exit 1
fi

MODIFIED_FILES=$(svn st | grep "^M" | sed 's/M[[:space:]]*//' | sed -E 's/$/;/' | tr ";" "\n")
for TO_COMMIT in ${MODIFIED_FILES};
do
	echo "!!! $TO_COMMIT"
	svn ci $TO_COMMIT \"$DESCRIPTION_STRING\"
	if [ $? -ne 0 ];
	then
		echo "$SCRIPT_NAME: cannot commit $TO_COMMIT"
	fi
done

NOT_UNDER_CONTROL_FILES=$(svn st | grep "^\?" | sed 's/\?[[:space:]]*//' | sed -E 's/$/;/' | tr ";" "\n")
for TO_ADD in $NOT_UNDER_CONTROL_FILES;
do
	echo "$SCRIPT_NAME: new file or folder $TO_ADD"
done

popd 1>/dev/null

exit 0
