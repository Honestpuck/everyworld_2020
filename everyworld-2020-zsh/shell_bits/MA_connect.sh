#!/bin/bash

# MA_connect.sh
#
# Connect to MobileAnywhere network
#
# This assumes that the mobileconfig for MA has already been loaded
# otherwise the addpreferredwirelessnetwork will fail with an authentication
# error
#

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

# promote Wi-Fi to top of service order
# build list of services
service_list=()
while read service; do
    service_list+=("$service")
done < <(networksetup -listnetworkserviceorder | grep "Hardware Port" | \
    grep -v "Wi-Fi" | sed 's#([^:]*:\ \([^,]*\),.*#\1#')
# do the promote
if [ "$DEBUG" == "True" ] ; then
    echo "Set order to: " $(printf "'%s' " "${service_list[@]}")
fi
networksetup -ordernetworkservices Wi-Fi "${service_list[@]}"
if [ "$DEBUG" == "True" ] ; then
    echo "Order set"
fi

# promote MobileAnywhere to top of preferred WiFi networks
# note index starts at 0
networksetup -removepreferredwirelessnetwork $WF MobileAnywhere > /dev/null
networksetup -addpreferredwirelessnetworkatindex $WF MobileAnywhere 0 WPA2 > /dev/null
if [ "$DEBUG" == "True" ] ; then
    echo "MA promoted"
fi

# toggle power on Wi-Fi to get a reconnect.
networksetup -setairportpower $WF off
networksetup -setairportpower $WF on
if [ "$DEBUG" == "True" ] ; then
    echo "Power bounced"
fi

# sleep 10 seconds to allow for connect time
sleep 10

# we are now on MA Wi-Fi

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

