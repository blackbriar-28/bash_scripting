#!/bin/bash -

HASH=$1
DIR=${2:-.}

# convert pathname into an absolute path
function mkpathabs ()
{
    if [[ $1 == /* ]]
    then
        ABS=$1
    else
        ABS="$PWD/$1"
    fi
}

find $DIR -type f |
while read fn
do
    THISONE=$(sha1sum "$fn")
    THISONE=${THISONE%% *}
    if [[ $THISONE == $HASH ]]
    then
        mkpathabs "$fn"
        echo $ABS
    fi
done