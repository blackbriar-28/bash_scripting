#!/bin/bash

HASH="${1:-}"
DIR="${2:-.}"

if [[ -z "$HASH" ]]; then
  echo "Usage: $0 <sha1-hash> [dir]" >&2
  exit 2
fi
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