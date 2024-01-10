#!/bin/bash

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
