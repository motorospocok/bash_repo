#!/bin/bash
if [ -z "$1" ]; then
		echo
		echo "usage1:"
		echo "sel_to_site.sh -l <additonal_diretctory path>"
		echo lists selection files under the SMO selection directory
		echo
		echo example: sel_to_site.sh -l ethtoja 
		echo "/var/opt/ericsson/nms_smo_srv/smo_file_store/Selection/ethtoja directory will be listed"
		echo 
		echo "usage2:"
		echo "sel_to_site.sh <selection_file_name_with_relative_path> <site_list_file_optional>"
		echo Makes a sitefile from selection file
		echo if not site_list given then the default name L14_site_file will be applied
		echo
		echo example: sel_to_site.sh ethtoja/example.sel gempa_site
		echo site file gempa_sh will be created from 
		echo "file example.sel under /var/opt/ericsson/nms_smo_srv/smo_file_store/Selection/ethtoja"
		echo and stored here
		echo
		echo script was made for TMobile Hu L14 project
		echo
              exit
          fi	
filenev=$1
filenev2=$2


if [ $filenev = "l" ]; then
	ls /var/opt/ericsson/nms_smo_srv/smo_file_store/Selection/$filenev2
else
	if [ -z "$2" ]; then
              filenev2=L14_site_file
         fi
	cat /var/opt/ericsson/nms_smo_srv/smo_file_store/Selection/$filenev | awk '{FS=","}{print $3}' | awk '{FS="="}{print $2}' > $filenev2
	echo Site file generation is completed
fi
