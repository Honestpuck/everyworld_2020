#!/bin/bash

# MA_disconnect.sh
#
# Disconnect from MobileAnywhere network
#
# This assumes you are on an open network port via Ethernet

# any errors and we are out of here
set -e
set -o pipefail

# do we want debug output
# check for flag
if [ "$#" -gt 0 ] && [ "$1" == '-D' ] ; then
    DEBUG="True"
fi
# DEBUG="True"

# discover device name of Wi-Fi network
WF=`networksetup -listnetworkserviceorder | grep "Wi-Fi," | sed "s#^([^:]*:[^:]*:\ \([a-z0-9]*\))#\1#"`

if [ "$DEBUG" == "True" ] ; then
    echo "Got WF: $WF"
fi

# turn WiFi off
networksetup -setairportpower $WF off
if [ "$DEBUG" == "True" ] ; then
    echo "Power off"
fi

# sleep 10 seconds to allow for connect time
sleep 10

# we are now off Wi-Fi and should be on corporate Ethernet

# run a little check
if [ "$DEBUG" == "True" ] ; then
    if ( curl -s www.google.com > /dev/null ) then
        if ( curl -s int.corp.sun > /dev/null ) then
            echo "** Up on Corporate"
        else
            echo "** Up on not corporate - assume MA"
        fi
    else
        echo "** Network down"
    fi
fi

