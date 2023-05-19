#!/bin/bash

# Check if all three arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 source_directory target_directory search_string"
  exit 1
fi

source_directory="$1"
target_directory="$2"
search_string="$3"
report_file="$target_directory/report.txt"

# Create the target directory if it doesn't exist
mkdir -p "$target_directory"

# Create or clear the report file
> "$report_file"

# Function to append a line to the report file
append_to_report() {
  echo "$1" >> "$report_file"
}

# Find files containing the search string in the source directory and its subdirectories
while IFS= read -r -d '' file; do
  if grep -q "$search_string" "$file"; then
    # Get the filename and directory path
    filename=$(basename "$file")
    directory=$(dirname "$file")

    # Check if the file already exists in the target directory
    if [ -e "$target_directory/$filename" ]; then
      # Append the directory path to the filename
      new_filename="$filename.$(basename "$directory")"
      cp "$file" "$target_directory/$new_filename"
      append_to_report "$file -> $target_directory/$new_filename"
    else
      cp "$file" "$target_directory"
      append_to_report "$file -> $target_directory/$filename"
    fi
  fi
done < <(find "$source_directory" -type f -print0)

echo "File search and copy completed. Report file created: $report_file"
