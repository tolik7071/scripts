#!/bin/bash
# $1 - working copy folder

SOURCE_DIR=$1
SCRIPT_NAME=`basename "$0"`

pushd "$SOURCE_DIR" 1>/dev/null

svn info &>/dev/null
if [ $? -ne 0 ];
then
	echo "$SCRIPT_NAME: `pwd` is not a working copy"
	exit 1
fi

#svn -R revert .
MODIFIED_FILES=$(svn st | grep "^M" | sed 's/M[[:space:]]*//' | sed -E 's/$/;/' | tr ";" "\n")
for TO_RESTORE in $MODIFIED_FILES;
do
	svn revert "$TO_RESTORE" 1>/dev/null
	if [ $? -ne 0 ];
	then
		echo "$SCRIPT_NAME: cannot restore $TO_RESTORE"
	fi
done

NOT_UNDER_CONTROL_FILES=$(svn st | grep "^\?" | sed 's/\?[[:space:]]*//' | sed -E 's/$/;/' | tr ";" "\n")
for TO_REMOVE in $NOT_UNDER_CONTROL_FILES;
do
	rm -fr "$TO_REMOVE"
	if [ $? -ne 0 ];
	then
		echo "$SCRIPT_NAME: cannot remove $TO_REMOVE"
	fi
done

popd 1>/dev/null

exit 0
