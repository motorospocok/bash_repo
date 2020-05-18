#!/bin/bash
if [ -z "$1" ]; then
		echo
		echo usage: site_to_sel.sh "<site_list_file> <selection_file_name>"
		echo Makes a selection file from sitelist file
		echo can used for T-Mobile Hu LTE sites only
		echo script was made for TMobile Hu L14 project
		echo
              exit
          fi	
filenev2=$2
if [ -z "$2" ]; then
		filenev2=selection_file.sel
          fi	

filenev=$1

cat $filenev | awk '{FS=" "}{print "SubNetwork=T-Mobile,SubNetwork=LTE,MeContext="$1",ManagedElement=1"}' > $filenev2

echo Site file generation is completed
