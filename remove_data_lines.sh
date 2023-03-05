#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <filename> <string>"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "Error: File $1 not found"
    exit 1
fi

# create a temporary file
tmpfile=$(mktemp)

# use grep to remove lines that start with the given string
grep -v "^$2" $1 > $tmpfile

# move the temporary file to the original file name
mv $tmpfile $1

echo "Lines starting with '$2' removed from $1"
