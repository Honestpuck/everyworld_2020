#!/bin/bash
#
# PromoteMA
# Promote MobileAnywhere to the top of the WiFi network list
#
# v1.0 ARW 2019-12-09
#

# find the WiFi network name
WF=`networksetup -listnetworkserviceorder | grep "Wi-Fi," | sed "s#^([^:]*:[^:]*:\ \([a-z0-9]*\))#\1#"`

# promote MobileAnywhere to top of preferred WiFi networks
# note index starts at 0
networksetup -removepreferredwirelessnetwork $WF MobileAnywhere > /dev/null
networksetup -addpreferredwirelessnetworkatindex $WF MobileAnywhere 0 WPA2 > /dev/null
