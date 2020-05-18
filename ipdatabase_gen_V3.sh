#!/bin/bash

## This script creates ipdatabase file for moshell operations - Version V3.

rm ipdatabase
ne_type=$1
if [ -z "$1" ]; then
		echo
              echo usage: 
		echo 		ipdatabase_gen_V3.sh rnc - generates ipdatabase file for RNC nodes only
		echo 		ipdatabase_gen_V3.sh rbs - generates ipdatabase file for cpp wcdma RBS nodes only
		echo 		ipdatabase_gen_V3.sh lte - generates ipdatabase file for cpp eRBS nodes only
		echo 		ipdatabase_gen_V3.sh g2  - generates ipdatabase file for g2 RBS nodes only
		echo 		ipdatabase_gen_V3.sh all - generates ipdatabase file for all node elements above
		echo
              exit 
fi
if [ $ne_type = "all" ]; then
	/opt/ericsson/ddc/util/bin/listme | grep -i @rnc | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" rnc"}' > ipdatabase
	/opt/ericsson/ddc/util/bin/listme | grep -i @rbs | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" rbs"}' >> ipdatabase
	/opt/ericsson/ddc/util/bin/listme | grep -i @erbs | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" rbs"}' >> ipdatabase
	/opt/ericsson/ddc/util/bin/listme | grep -i ecim | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" -v username=integrator,password=rbs1234"}' >> ipdatabase
fi
if [ $ne_type = "rbs" ]; then
	ne_psw="rbs"
	/opt/ericsson/ddc/util/bin/listme | grep -i @$ne_type | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" rbs"}' > ipdatabase
fi
if [ $ne_type = "rnc" ]; then
	/opt/ericsson/ddc/util/bin/listme | grep -i @$ne_type | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" rnc"}' > ipdatabase
fi
if [ $ne_type = "lte" ]; then
	/opt/ericsson/ddc/util/bin/listme | grep -i @erbs | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" rbs"}' > ipdatabase
fi
if [ $ne_type = "g2" ]; then
	/opt/ericsson/ddc/util/bin/listme | grep -i ecim | awk 'BEGIN { FS = "@" } { print $1," ", $2 }' | awk 'BEGIN { FS = "=" } {print $4" -v username=integrator,password=rbs1234"}' >> ipdatabase
fi
echo Ipdatabase file generating is completed
echo
read -p "Do you want to copy the file to ~/moshell/sitefile?" valasz
if [ $valasz = "y" ]; then
	cp ipdatabase ~/moshell/sitefiles/
	echo Sitefile is now copied.
	exit
fi
echo "Site file is not copyed. Bye."
exit 
