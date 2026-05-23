#!/bin/bash

# Cybersecurity Ops with bash
# osdetect.sh - Detects the OS of a target system
#
# Description:
# Distinguish between MS-Windows, Linux, and MacOS
#
# Usage: bash osdetect.sh
# output will be one of: Linux, MSWin, MacOS

function getOS()
{
    if [[ "$(uname)" == Windows ]]
    then
        OS="MSWin"
    elif [[ "$(uname)" == Linux ]]
    then
        OS="Linux"
    else
        OS="MacOS"
    fi
}

getOS
echo $OS