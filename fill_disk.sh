#!/bin/bash
# $1 - mount point
# $2 - requested available size (in bytes)

SOURCE_DIR=$1
SCRIPT_NAME=`basename "$0"`

MOUNT_POINT=$1
REQUESTED_SIZE=$2
BLOCK_SIZE=10485760 # 10M

if [[ -z $MOUNT_POINT ]] || [[ -z $REQUESTED_SIZE ]];
then
	echo -e "$SCRIPT_NAME: Usage:\t\`$SCRIPT_NAME mount_point requested_size_in_bytes\`"
	exit 1
fi

if [ -z $BLOCKSIZE ];
then
#	echo "$SCRIPT_NAME: block size set to $BLOCK_SIZE bytes"
	export BLOCKSIZE=$BLOCK_SIZE
fi

while true;
do
	AVAILABLE_SIZE=$(df $MOUNT_POINT | grep "^\/" | awk '{ print $4 }')
	let AVAILABLE_SIZE*=BLOCKSIZE;
	
#	echo "$SCRIPT_NAME: available $AVAILABLE_SIZE, requested $REQUESTED_SIZE"
	
	if [ $REQUESTED_SIZE -ge $AVAILABLE_SIZE ];
	then
#		echo "$SCRIPT_NAME: available $AVAILABLE_SIZE, requested $REQUESTED_SIZE"
		exit 0
	fi

	SPACE_TO_FILL=$[ AVAILABLE_SIZE - REQUESTED_SIZE ]
	let SPACE_TO_FILL/=BLOCKSIZE
	
#	echo "$SCRIPT_NAME: block size $BLOCKSIZE, block count $SPACE_TO_FILL"

	dd if=/dev/zero of=/tmp/`uuidgen`.zero bs=$BLOCKSIZE count=$SPACE_TO_FILL
	if [ $? -ne 0 ];
	then
		exit 1
	fi
done

exit 0
