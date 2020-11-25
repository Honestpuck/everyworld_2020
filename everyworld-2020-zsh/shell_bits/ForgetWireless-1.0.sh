#!/bin/bash
#
# ForgetWireless.sh
# v1.0 ARW 02/07/2019
#
# Clear WiFi autojoin list
#

# checks if a value is an item in an array. Pass value to be searched for then array 
# containsElement "$value" "${array[@]}"
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

port=`networksetup -listnetworkserviceorder | grep "Wi-Fi," | sed "s#^([^:]*:[^:]*:\ \([a-z0-9]*\))#\1#"`
current=$(networksetup -getairportnetwork $port | sed -e 's/Current Wi-Fi Network: \(.*\)/\1/')
skip=("MobileAnywhere" "${current}")

while read -r wf ; do
	if (! containsElement "$wf" "${skip[@]}") ; then
		networksetup -removepreferredwirelessnetwork $port "$wf" > /dev/null
	fi
done <<< "$(networksetup -listpreferredwirelessnetworks $port | grep -v 'Preferred networks')"
