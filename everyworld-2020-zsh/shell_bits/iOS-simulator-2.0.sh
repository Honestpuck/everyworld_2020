#!/bin/bash

# iOS_simulator.sh v1.0
# ARW 1/12/2019
# Installs a chosen iOS simulator

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

XCVERSIONBINARY=$(sudo su $loggedInUser -c zsh "which xcversion")

echo $XCVERSIONBINARY
exit

if [[ ! $XCVERSIONBINARY ]]; then
	echo "Xcode-Select missing"
	exit 1
fi


exit

app=$(osascript <<EOF
set variableName to do shell script "/usr/local/lib/ruby/gems/2.7.0/bin/xcversion simulators | grep 'iOS.*not' | sort -u"
set testArray to paragraphs of the variableName
set selectedApp to {choose from list testArray}
return selectedApp
EOF
)

sim=$(echo ${app} | sed 's#\ S.*$##')


/usr/local/lib/ruby/gems/2.7.0/bin/xcversion simulators --install="${sim}"

/usr/local/bin/terminal-notifier -sound default -title "iOS installer" \
				 -contentImage /Library/Management/Assets/macsuncorp-light.png \
				 -message "iOS simulator install complete"
