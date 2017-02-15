#!/bin/bash
# $1 - source file mask
# $2 - resulting file mask
# example: rename 18.* 19.*

SCRIPT_NAME=`basename "$0"`
SOURCE_DIR=`dirname "$1"`
FILE_LIST=$(find "$SOURCE_DIR" -name $1)
echo "$FILE_LIST"

#TEST_STRING="test.ttt.png"
#echo "${TEST_STRING%.*}"	# test.ttt
#echo "${TEST_STRING%%.*}"	# test
#echo "${TEST_STRING#*.}"	# ttt.png
#echo "${TEST_STRING##*.}"	# png

#KPX_DVD_TITLE_Spanish="Kid Pix 3D España"
#LOCALIZATION="Spanish"
#eval $(echo "KPX_DVD_TITLE=\"\${KPX_DVD_TITLE_${LOCALIZATION}}\"")
#echo $KPX_DVD_TITLE

exit 0
