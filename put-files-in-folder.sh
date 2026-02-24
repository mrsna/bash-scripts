#!/bin/bash

# This script organizes files in a specified directory by moving each file 
# into a new subdirectory named after the file (without the extension). 
# For example, a file named `example.mp4` will be moved to `example/example.mp4`.
# 
# Usage:
# To run the script, provide the path to the target directory as an argument:
#   - `./script_name.sh <path>`
# Ensure that the specified directory exists, or an error will be reported.

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

SOURCE_DIR="$1"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

for file in "$SOURCE_DIR"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        dirname="${filename%.*}"
        if [ ! -d "$SOURCE_DIR/$dirname" ]; then
            mkdir -p "$SOURCE_DIR/$dirname"
        fi
        mv "$file" "$SOURCE_DIR/$dirname/"
    fi
done
