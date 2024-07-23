#!/bin/bash
# Check if a directory was provided as an argument
# This script written for to remove duplicated lines from the Health check collector result files
# Run it after the Healthcheck mos file completion

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Get the directory from the first argument
DIRECTORY="$1"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory not found!"
    exit 1
fi

# Loop through all files in the directory that start with "prehc" or "posthc"
for FILENAME in "$DIRECTORY"/preHC* "$DIRECTORY"/postHC*; do
    # Check if the file exists
    if [ -f "$FILENAME" ]; then
        # Read the first line of the file
        FIRST_LINE=$(head -n 1 "$FILENAME")

        # Create a temporary file to store the results
        TEMP_FILE=$(mktemp)

        # Write the first line to the temporary file
        echo "$FIRST_LINE" > "$TEMP_FILE"

        # Append the rest of the lines, excluding those that match the first line
        tail -n +2 "$FILENAME" | grep -v "^$FIRST_LINE$" >> "$TEMP_FILE"

        # Replace the original file with the temporary file
        mv "$TEMP_FILE" "$FILENAME"

        echo "Processed file: $FILENAME"
    fi
done

echo "All matching files processed."
