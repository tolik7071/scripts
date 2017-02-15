#!/bin/bash
# TODO: cleans the current repository and switches to Develop branch.

function CleanPath
# $1 - submodule path
{
#git clean -d -f
#git reset file_name

    pushd "$1" 1>/dev/null

    echo "Cleaning '$1'..."

    MODIFIED_FILES=$(git diff --name-status | egrep '[^M]' | sed 's/^[M].//')

    OLD_IFS=$IFS
    IFS=$'\n'

    for CURRENT_PATH in $MODIFIED_FILES
    do
        if [ ! -d "$CURRENT_PATH" ];
        then
            echo "$CURRENT_PATH"
        fi
    done

    IFS=$OLD_IFS

    popd 1>/dev/null
}

#IS_IN_DEVELOP=$(git branch 2>/dev/null | egrep '^\*' | egrep 'develop')
IS_REPO=$(git status 2>/dev/null)
if [[ $IS_REPO = "" ]];
then
    echo "ERROR: Its seem \"`pwd`\" not a repository."
    exit 1
fi

CleanPath "."

ALL_SUBMODULES=$(git submodule status --recursive | awk '{ print $2 }')

OLD_IFS=$IFS
IFS=$'\n'

for CURRENT_SUBMODULE in $ALL_SUBMODULES
do
    CleanPath "$CURRENT_SUBMODULE"
done

IFS=$OLD_IFS

exit 0
