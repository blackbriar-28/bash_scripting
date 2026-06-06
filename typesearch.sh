#!/bin/bash -
# Cybersecurity Ops with bash
# typesearch.sh

# Description:
# Search the file system for a given file type. It prints out the pathname when found.

# Usage:
# typesearch.sh [-c dir] [-i] [-R|r] <pattern> <path>
#     -c Copy files found to dir
#     -i Ignore case
#     -R|r Recursively search subdirectories
#     <pattern> File type pattern to search for
#     <path> Path to start search

DEEPORNOT="-maxdepth 1" # Just the current dir; default

# PARSE option arguments:
while getopts 'c:iRr' opt; do
  case "${opt}" in
    c) # Copy found files to specified directory
      if [[ -z "$OPTARG" || "$OPTARG" == -* ]] # Check if OPTARG is empty or looks like an option (starts with '-')
      then
        echo "ERROR: The -c option requires a destination directory." >&2
        echo "DETAIL: You provided '$OPTARG', which looks like an option, not a directory." >&2
        echo "USAGE: $0 [-c dir] [-i] [-R|r] <pattern> <path>" >&2
        echo "EXAMPLE: $0 -c /tmp/matches -R txt ." >&2
        exit 2
      fi
      COPY=YES
      DESTDIR="$OPTARG"
      ;;
    i) # Ignore u/l case differences in search
      CASEMATCH="-i"
      ;;
    [Rr]) # recursive
      unset DEEPORNOT;;
    *) # unknown/unsupported option
       # error mesg wil come from getopts, so just exit
       exit 2 ;;
  esac
done
shift $((OPTIND - 1))

PATTERN=${1:-PDF document} # Default pattern if not provided
STARTDIR=${2:-.} # Default to current directory if not provided

find $STARTDIR $DEEPORNOT -type f | while read FN
do
  file $FN | egrep -q $CASEMATCH "$PATTERN"
  if (( $? == 0 )) # found a match
  then
    echo $FN
    if [[ $COPY ]]
    then
      cp -p $FN $DESTDIR
    fi
  fi
done