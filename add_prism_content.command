#!/bin/bash

cd ~/Library/Developer/Xcode/DerivedData/

find . -iname 'Prism.app' -exec cp -fr ~/Projects/prism_mac/Installer/Product/Application/Contents/SharedSupport {}/Contents/ \;

exit 0
