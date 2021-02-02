#!/bin/bash

rm latestmoshellversion.txt 2> /dev/null
jelenlegi=`cat ~/moshell/moshell | grep -a -m 1 "^moshell_version=" | sed 's/.*="//g' | sed 's/"$//g'`
echo "CURRENT VERSION: $jelenlegi"
echo "...."
wget http://newtran01.au.ao.ericsson.se/moshell/downloads/latestmoshellversion.txt &> /dev/null
uj=`cat latestmoshellversion.txt`
rm latestmoshellversion.txt

echo "Legújabb: $uj"

if [ "$jelenlegi" = "$uj" ]; then
	echo "The MoShell is up to date! :)"
  else
	echo "There is a newer version on the server. Do you want to update moshell? y/n"
	read answer
	if [ "$answer" = "y" ]; then
	rm ~/install_moshell/*
        cd ~
        wget http://newtran01.au.ao.ericsson.se/moshell/downloads/moshell$uj.zip
	cp moshell$uj.zip ~/install_moshell
	rm moshell$uj.zip
	rm -R ~/moshell
	cd ~/install_moshell
	unzip -o moshell$uj.zip
	bash moshell_install
	fi
fi
