#!/bin/bash

# Check if both arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 file spaces"
  exit 1
fi

file="$1"
spaces="$2"

# Check if the file exists
if [ ! -f "$file" ]; then
  echo "File '$file' does not exist."
  exit 1
fi

# Check if the number of spaces is a positive integer
if ! [[ "$spaces" =~ ^[1-9][0-9]*$ ]]; then
  echo "Number of spaces must be a positive integer."
  exit 1
fi

# Create the indentation string with the specified number of spaces
indentation=$(printf "%${spaces}s")

# Create the output file name
output_file="new_${file}"

# Add the spaces to the beginning of each line and save the modified content to the output file
sed "s/^/$indentation/" "$file" > "$output_file"

echo "Added $spaces spaces to the beginning of each line in '$file'."
echo "Modified content saved to '$output_file'."
