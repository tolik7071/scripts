#!/bin/bash
# TODO:
# $1 - path to prism_mac/.../prism_core/Sources/Application/Models/Ported
# $2 - path to prism_win

if [[ $# -ne 4 ]]
then
    printf "Usage: `basename $0` path_to_mac_src path_to_win_src new_revision prev_revision\n"
    exit 1
fi

PORTED_DIR=$1
if [[ $PORTED_DIR == "" ]] || [[ ! -d $PORTED_DIR ]];
then
    printf "No such folder: \'$PORTED_DIR\'\n"
    exit 1
fi

WIN_DIR=$2
if [[ $WIN_DIR == "" ]] || [[ ! -d $WIN_DIR ]];
then
    printf "No such folder: \'$WIN_DIR\'\n"
    exit 1
fi

NEW_REVISION=$3
PREV_REVISION=$4

OUT_DIR="$HOME/Desktop/`uuidgen`"
mkdir -p "$OUT_DIR"

CURRENT_DIR=$(pwd)

pushd ${WIN_DIR} 1>/dev/null
#git rev-parse HEAD

echo "ADDED:"
git diff $NEW_REVISION $PREV_REVISION --name-status | grep ^[A] | sed 's/^[A].//'

echo "REMOVED:"
git diff $NEW_REVISION $PREV_REVISION --name-status | grep ^[D] | sed 's/^[D].//'

CHANGED_FILES=$(git diff $NEW_REVISION $PREV_REVISION --name-status | grep ^[M] | sed 's/^[M].//')
popd 1>/dev/null

DIFF_APP="/Applications/Xcode.app/Contents/Applications/FileMerge.app/Contents/MacOS/FileMerge"

OLD_IFS=$IFS
IFS=$'\n'

for CURRENT_FILE in $CHANGED_FILES
do
    WIN_FILE="$WIN_DIR/$CURRENT_FILE"
    if [ -f ${WIN_FILE} ];
	then
        LEFT_FILE=$(find "${PORTED_DIR}" -iname "`basename $CURRENT_FILE`")
        if [ ${#LEFT_FILE} -ge 1 ];
        then
            export LANG="en"
            RIGHT_FILE="$OUT_DIR/`basename $CURRENT_FILE`"
            cp $WIN_FILE $OUT_DIR
#            tr -d '\r' < $WIN_FILE | awk '// { gsub("WINBOOL","BOOL"); gsub("BOOL","WINBOOL"); print $0 };' > $RIGHT_FILE
            $($DIFF_APP -left "${LEFT_FILE}" -right "${RIGHT_FILE}" 2>/dev/null)
#            echo "$DIFF_APP -left \"${LEFT_FILE}\" -right \"${RIGHT_FILE}\""
        fi
	fi
done

IFS=$OLD_IFS

exit 0
