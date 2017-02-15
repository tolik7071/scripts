#!/bin/bash

cd ~/Library/Developer/Xcode/DerivedData/

find . -iname "OberlinX-*" -maxdepth 1 -exec rm -fR {} \;

exit 0