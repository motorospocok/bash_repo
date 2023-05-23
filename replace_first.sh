#!/bin/bash

# Check if all four arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
  echo "Usage: $0 file1 file2 [string1] [string2]"
  exit 1
fi

file1="$1"
file2="$2"
output_file="new_$2"

if [ "$#" -ge 3 ]; then
  string1="$3"
else
  string1="BEGIN CERTIFICATE"
fi

if [ "$#" -eq 4 ]; then
  string2="$4"
else
  string2="END CERTIFICATE"
fi

# Find the line numbers of the first occurrence of string1 and string2 in file2
start_line=$(grep -n "$string1" "$file2" | head -n 1 | cut -d ':' -f 1)
end_line=$(grep -n "$string2" "$file2" | head -n 1 | cut -d ':' -f 1)

# Check if both strings are found in file2
if [ -z "$start_line" ] || [ -z "$end_line" ]; then
  echo "One or both strings not found in file2"
  exit 1
fi

# Copy the content of file2 to the output file
cp "$file2" "$output_file"


# Replace the content between the start and end lines in the output file with the content of file1
sed -i "${start_line},${end_line}d" "$output_file"  # Delete the lines between start_line and end_line
start_line=$((start_line-1))
sed -i "${start_line}r ${file1}" "$output_file"     # Insert the content of file1 at start_line

echo "Content between the first occurrence of '$string1' and '$string2' in $file2 replaced with the content of $file1"
echo "Modified content saved to $output_file"
