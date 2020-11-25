#!/bin/sh

SAVEIFS=$IFS
IFS=$'\n'

for i in `networksetup -listallnetworkservices`; do
    if [ `echo $i | grep -c '*'` -lt 1 ]; then
        networksetup -setv6off "$i"
    fi
done

IFS=$SAVEIFS
exit 0