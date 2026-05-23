#!/bin/bash
#
# distro.sh
#
# Description:
# Prints the name of the current Linux distribution.
# e.g. Ubuntu, Alma Linux, Amazon Linux, Fedora, Debian, etc.
#
# Usage: bash distro.sh

if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$NAME"
elif [ -f /etc/redhat-release ]; then
    # Fallback for older RHEL/CentOS systems
    cat /etc/redhat-release | sed 's/ release.*//'
elif [ -f /etc/debian_version ]; then
    echo "Debian"
else
    echo "Unknown Linux distribution"
fi
