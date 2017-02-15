#!/bin/bash


# -eq -> =
# -ne -> !=
# -gt -> >
# -ge -> >=
# -lt -> <
# -le -> <=

if [ 2 -ne 2 ];
then
    echo "2 != 2"
else
    echo "2 == 2"
fi

if (( 2 != 2 ));
then
    echo "2 != 2"
else
    echo "2 == 2"
fi

#while [ $# -gt 0 ]
#do
#    FILE=$1
#    echo "$FILE"
#    shift
#done

exit 0