#!/bin/bash
# TODO:
# $1 - path to prism_mac
# $2 - path to prism_win
# $3 - hash of revision which been used for previous merge

if [[ $# -ne 3 ]]
then
    printf "Usage:\n\t`basename $0` path_to_mac_src path_to_win_src prev_revision\n"
    exit 1
fi

MAC_DIR=$1
if [[ $MAC_DIR == "" ]] || [[ ! -d $MAC_DIR ]];
then
    printf "No such folder: \'$MAC_DIR\'\n"
    exit 1
fi

WIN_DIR=$2
if [[ $WIN_DIR == "" ]] || [[ ! -d $WIN_DIR ]];
then
    printf "No such folder: \'$WIN_DIR\'\n"
    exit 1
fi

MERGE_RESULT_FILE="$HOME/Desktop/merge_result.txt"

LAST_USED_WIN_COMMIT_HASH=$3

pushd ${WIN_DIR} 1>/dev/null

CURRENT_WIN_COMMIT_HASH=$(git rev-parse HEAD)
printf "Current commit $CURRENT_WIN_COMMIT_HASH\n\n" > $MERGE_RESULT_FILE

printf "ADDED FILES:\n" >> $MERGE_RESULT_FILE
git diff $CURRENT_WIN_COMMIT_HASH $LAST_USED_WIN_COMMIT_HASH --name-status \
    | grep ^[A] | sed 's/^[A].//' >> $MERGE_RESULT_FILE

printf "REMOVED FILES:\n" >> $MERGE_RESULT_FILE
git diff $CURRENT_WIN_COMMIT_HASH $LAST_USED_WIN_COMMIT_HASH --name-status \
    | grep ^[D] | sed 's/^[D].//' >> $MERGE_RESULT_FILE

CHANGED_FILES=$(git diff $CURRENT_WIN_COMMIT_HASH $LAST_USED_WIN_COMMIT_HASH --name-status \
    | grep ^[M] | sed 's/^[M].//')

popd 1>/dev/null

#DIFF_APP="/Applications/Xcode.app/Contents/Applications/FileMerge.app/Contents/MacOS/FileMerge"
DIFF_APP="opendiff"

#if [ ! -d $DIFF_APP ];
#then
#    echo "No such app: $DIFF_APP"
#    exit 1
#fi

OLD_IFS=$IFS
IFS=$'\n'

for CURRENT_FILE in $CHANGED_FILES
do
    CURRENT_FILE_NAME=$(basename $CURRENT_FILE)
#    echo "$CURRENT_FILE_NAME"

    LEFT_FILE=$(find $WIN_DIR -name $CURRENT_FILE_NAME)
    RIGHT_FILE=$(find $MAC_DIR -name $CURRENT_FILE_NAME)

    if [[ $RIGHT_FILE != "" ]];
    then
#        echo "->$LEFT_FILE"
#        echo "->$RIGHT_FILE"
#        $($DIFF_APP -left "${LEFT_FILE}" -right "${RIGHT_FILE}" 2>/dev/null)
        $($DIFF_APP "${LEFT_FILE}" "${RIGHT_FILE}" 2>/dev/null)
    else
        printf "Does not exist in MAC repository: $LEFT_FILE\n" >> $MERGE_RESULT_FILE
    fi
done

IFS=$OLD_IFS

exit 0
