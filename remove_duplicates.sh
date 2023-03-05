#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "Error: File $1 not found"
    exit 1
fi

# create a temporary file
tmpfile=$(mktemp)

# sort the input file and remove duplicates
sort -u $1 > $tmpfile

# move the temporary file to the original file name
mv $tmpfile $1

echo "Duplicates removed from $1"