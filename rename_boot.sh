#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <directory_path> <new_filename>"
	exit 1
fi

directory_path="$1"
new_filename="$2"

first_file=$(find "$directory_path" -type f | sort | head -n 1)

if [ -z "$first_file" ]; then
	echo "No file found in the directory."
	exit 1
fi

new_file_path=$(dirname "$first_file")/"$new_filename"

mv "$first_file" "$new_file_path"

echo "Renamed '$first_file' to '$new_file_path'"
