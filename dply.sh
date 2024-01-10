#!/bin/bash

vdu_node=$(oc get project | grep -i vdu)
if [[ $vdu_node == *vdu* ]]; then
 node_info=$(oc get node)
 l2=$(echo "$node_info" | sed -n '2p'| awk BEGIN'{FS="."}{print $1}')
 oc project vdu
 node_info=$(helm list)
 version=$(echo "$node_info" | sed -n '2p'|awk BEGIN'{FS=" "}{print $9}')
 version1="${version#eric-ran-du-nr-}"
 echo " "
 echo "********************************************************************"
 echo VDU node $l2 is running on version: $version1
 echo "********************************************************************"
 echo " "
 echo "************** Deploy Label ***************"
 echo " "
 echo $l2:
 echo \ \ \ version: $version1
 echo \ \ \ operation: install
 echo \ \ \ deployOption: --set node.moconfig=true --set node.waitForInstall=600
 echo " "
 echo "************** Deploy Label ***************"
fi

vcu_node=$(oc get project | grep -i keep)
 if [[ $vcu_node == *keep* ]]; then
 # Run the 'oc project list' command and store the output in a variable
 output=$(oc get projects | grep -i keep | awk 'BEGIN {FS=" "}{print $1}')

 # Initialize an empty array to hold the lines that contain 'keep'
 keep_lines=()

 # Loop through each line in the output and check if it contains 'keep'
 while IFS= read -r line; do
   if [[ "$line" == *"keep"* ]]; then
     # If the line contains 'keep', add it to the array
    keep_lines+=("$line")
   fi
 done <<< "$output"

 # Print the array of lines containing 'keep'
 printf '%s\n' "${keep_lines[@]}"

 # Loop through each element in the 'keep_lines' array and run the 'oc array element' command
 for element in "${keep_lines[@]}"; do
   oc project "$element"
   temp=$(helm list | grep -i keep | awk 'BEGIN {FS=" "}{print $10}')
   version+=("$element"' is running on '"$temp")
 done
 echo ' '
 echo '******************************************'
 printf '%s\n' "${version[@]}"
 echo '******************************************'
 for element in "${keep_lines[@]}"; do
  oc project "$element"
  if [[ "$element" == *"01"* ]]; then
   node="${element#keep-}"
   node="$node-cu-cp"
  fi
  if [[ "$element" == *"02"* ]]; then
   node="${element#keep-}"
   node="$node-cu-up"
  fi
  if [[ "$element" == *"03"* ]]; then
   node="${element#keep-}"
   node="$node-rans"
  fi
  temp=$(helm list | grep -i keep | awk 'BEGIN {FS=" "}{print $10}')
  echo " " >> temp_file.txt
  echo $node: >> temp_file.txt
  echo \ \ \ version: $temp >> temp_file.txt
  echo \ \ \ operation: install >> temp_file.txt
  echo \ \ \ deployOption: --set node.waitForInstall=600 >> temp_file.txt
  echo " " >> temp_file.txt
 done
 echo " "
 echo "************** Deploy Label ***************"
 cat temp_file.txt
 echo "************** Deploy Label ***************"
 rm temp_file.txt
fi

