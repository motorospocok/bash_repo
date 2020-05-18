#!/bin/bash

 if [ -z "$1" ]; then
		echo "*** NE element search in OSS ***"
		echo "Type the name or some letters from the NE name:"
		read ne_name
		ne_name='MeContext='$ne_name
		echo "The following network element(s) has/have been found:"
	/opt/ericsson/ddc/util/bin/listme | grep -i $ne_name | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4}'
              alma=$(/opt/ericsson/ddc/util/bin/listme | grep -i $ne_name | awk 'BEGIN { FS = "@" } { print $2 }')
		echo "Continue with moshell?"
		read answer
		if [ $answer = "y" ]; then
			~/moshell/moshell $alma
		fi
		exit
          fi
	  ne_name='MeContext='$1
echo "The following network element(s) has/have been found:"
/opt/ericsson/ddc/util/bin/listme | grep -i $ne_name | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4}'
alma=$(/opt/ericsson/ddc/util/bin/listme | grep -i $ne_name | awk 'BEGIN { FS = "@" } { print $2 }')
echo "Continue with moshell?"
read answer
if [ $answer = "y" ]; then
		~/moshell/moshell $alma
fi
exit