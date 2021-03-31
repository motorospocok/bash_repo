#!/bin/bash
#This script creates ENM files from a list file and batch files
#Written for support Telekom ENM gempa

if [ -z "$1" ]; then
              echo usage: Main_switch.sh "<output file prefox> <sites per batch> <site list file>"
              echo " example ./Main_switch.sh RNC 4 sites.txt"
              exit
          fi 

SITE_NAME=($(cat $3))
number=${#SITE_NAME[@]}
count=$2

mkdir $1
mkdir $1/turn_off_batch
mkdir $1/turn_on_batch

let count=$count*4
((number--))
echo ' Generating Supervision files - to be loaded to old and the new ENM'
c=1
for ((b=0;b<=$number;b++))
	do 
		echo 'cmedit set '${SITE_NAME[$b]}' CmNodeHeartbeatSupervision active=true' >> Turn_on_file_$1.txt
		echo 'cmedit set '${SITE_NAME[$b]}' PmFunction pmEnabled=true' >> Turn_on_file_$1.txt
		echo 'cmedit set '${SITE_NAME[$b]}' InventorySupervision active=true' >> Turn_on_file_$1.txt
		echo 'alarm enable '${SITE_NAME[$b]} >> Turn_on_file_$1.txt
		
		echo 'cmedit set '${SITE_NAME[$b]}' CmNodeHeartbeatSupervision active=false' >> Turn_off_file_$1.txt
		echo 'cmedit set '${SITE_NAME[$b]}' PmFunction pmEnabled=false' >> Turn_off_file_$1.txt
		echo 'cmedit set '${SITE_NAME[$b]}' InventorySupervision active=false' >> Turn_off_file_$1.txt
		echo 'alarm disable '${SITE_NAME[$b]} >> Turn_off_file_$1.txt
	done
split -l $count -d Turn_off_file_$1.txt Turn_off_file_$1.txt_
split -l $count -d Turn_on_file_$1.txt Turn_on_file_$1.txt_

cp Turn_on_file_$1.txt_* $1/turn_on_batch
cp Turn_off_file_$1.txt_* $1/turn_off_batch
cp Turn_on_file_$1.txt $1
cp Turn_off_file_$1.txt $1

rm Turn_*