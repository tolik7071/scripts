#!/bin/bash

TIFF_UTIL="tiffutil"

# check for arguments
if [ $# -lt 2 ];
then
    echo -e "Usage: `basename $0` file1 [file2 ...]" 1>&2
    exit 1
fi

#-cathidpicheck

RESULT_FILE_NAME="`uuidgen`.tiff"

$($TIFF_UTIL -cathidpicheck "$@" -out $RESULT_FILE_NAME)

#while [ $# -gt 0 ]
#do
#    FILE=$1
#    echo "$FILE"
#    shift
#done

exit 0