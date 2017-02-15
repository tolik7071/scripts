#!/bin/bash
# $1 - source file
# $2 - image to attach to the source file

SOURCE_FILE=$1
ATTACHED_IMAGE=$2
SCRIPT_NAME=`basename "$0"`

# check for arguments
if [ $# -ne 2 -o "$SOURCE_FILE" = "" -o "$ATTACHED_IMAGE" = "" ]; then
	echo -e "Usage: $SCRIPT_NAME <source file> <image>" 1>&2
	exit 1
fi

# check for existen files
if [ ! -f "$SOURCE_FILE" -o ! -f "$ATTACHED_IMAGE" ]; then
	echo -e "$SCRIPT_NAME:$LINENO: no such file(s)" 1>&2
	exit 1
fi

# check for developer tools
DEV_TOOLS_FOLDER_NEW="/Applications/Xcode.app/Contents/Developer/Tools"
DEV_TOOLS_FOLDER_OLD="/Developer/Tools"
DEV_TOOLS_FOLDER="$DEV_TOOLS_FOLDER_NEW"
if [ ! -d "$DEV_TOOLS_FOLDER_NEW" ]; then
	if [ ! -d "$DEV_TOOLS_FOLDER_OLD" ]; then
		echo -e "$SCRIPT_NAME:$LINENO: developer tools not found" 1>&2
		exit 1
	else
		DEV_TOOLS_FOLDER="$DEV_TOOLS_FOLDER_OLD"
	fi
fi

# TODO: case when an icon is used
IMAGE_TYPE=`echo "$ATTACHED_IMAGE" | sed -e 's/^.*\.//'`
if [ "$IMAGE_TYPE" = "icns" ]; then
	echo -e "$SCRIPT_NAME:$LINENO: currently not supported" 1>&2
	exit 1
fi

# add a Finder icon to image file (to the resource fork)
sips -i "$ATTACHED_IMAGE" 1>/dev/null
RESULT=$?
if [ 0 -ne $RESULT ]; then
	echo -e "$SCRIPT_NAME:$LINENO: cannot create icon" 1>&2
	exit 2
fi

# create tmp dir
TEMP_DIR=$(mktemp -d /tmp/"$SCRIPT_NAME".$(uuidgen))

# extract an icon to its own resource file
RESOURCE_FILE_NAME="$TEMP_DIR/`basename $ATTACHED_IMAGE`.rsrc"
"$DEV_TOOLS_FOLDER/DeRez" -only icns "$ATTACHED_IMAGE" > "$RESOURCE_FILE_NAME"
RESULT=$?
if [ 0 -ne $RESULT ]; then
	echo -e "$SCRIPT_NAME:$LINENO: cannot create resource file" 1>&2
	exit 2
fi

# append a resource to the source file
"$DEV_TOOLS_FOLDER/Rez" -append "$RESOURCE_FILE_NAME" -o "$SOURCE_FILE" 1>/dev/null
RESULT=$?
if [ 0 -ne $RESULT ]; then
	echo -e "$SCRIPT_NAME:$LINENO: cannot add resource to the file" 1>&2
	exit 2
fi

# set an attribute 'CUSTOM ICON'
"$DEV_TOOLS_FOLDER/SetFile" -a C "$SOURCE_FILE" 1>/dev/null
RESULT=$?
if [ 0 -ne $RESULT ]; then
	echo -e "$SCRIPT_NAME:$LINENO: cannot set an attribute" 1>&2
	exit 2
fi

exit 0
