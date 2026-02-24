#!/bin/bash

# This script organizes files within a specified directory by moving all 
# files from its subdirectories into the main directory. It then cleans up 
# by deleting any empty subdirectories and removing files smaller than 10 MB.
# 
# Usage:
# To execute the script, provide the path to the target directory as an argument:
#   - `./script_name.sh <path>`
# Ensure that the specified path is a valid directory, or an error will be reported.

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

MAIN_DIR="$1"

if [ ! -d "$MAIN_DIR" ]; then
  echo "The specified path is not a directory or does not exist."
  exit 1
fi

# Move files from subdirectories to the main directory
find "$MAIN_DIR" -mindepth 2 -type f -exec mv -f -t "$MAIN_DIR" -- {} +

# Check if moving files was successful
if [ $? -ne 0 ]; then
  echo "Error moving files."
  exit 1
fi

# Delete empty directories
find "$MAIN_DIR" -mindepth 1 -type d -empty -delete

# Check if deleting empty folders was successful
if [ $? -ne 0 ]; then
  echo "Error deleting empty folders."
  exit 1
fi

# Delete files smaller than 10 MB
find "$MAIN_DIR" -maxdepth 1 -type f -size -10M -delete

# Check if deleting small files was successful
if [ $? -ne 0 ]; then
  echo "Error deleting files smaller than 10MB."
  exit 1
fi

echo "Moving and cleanup done."

