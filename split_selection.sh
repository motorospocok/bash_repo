#!/bin/bash
site_name=($(cat l14_ip12_s1_403.sel))
echo ${site_name[2]}
number=${#site_name[@]}
((number--))

name=1_
for ((b=0;b<=$number;b++))	
	do 
		if [ $b -ge 50 ] && [ $b -le 101 ]
		then
			name=2_
		fi
		if [ $b -ge 100 ] && [ $b -le 151 ]
		then
			name=3_
		fi



	done
