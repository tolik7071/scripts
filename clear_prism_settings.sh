#!/bin/bash

PWD=$(pwd)

PLIST_TO_DELETE=$(ls -R ~/Library/Preferences/ | grep 'Prism')
cd ~/Library/Preferences/

for CURRENT_FILE in $PLIST_TO_DELETE
do
	rm -f $CURRENT_FILE
done

cd $PWD

exit 0
