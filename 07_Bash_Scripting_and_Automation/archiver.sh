#!/bin/bash
#
# Script to create a tar+gz archive from a folder
#

# Function to display help message
help_message() {
  echo "Script usage: $0 folder_to_archive path/name_of_archive"
  echo "Parameters:"
  echo "  folder_to_archive   : The existing folder to be archived"
  echo "  path/name_of_archive: The non-existing tar+gz archive file"
}

# Check if script receives two parameters
if [ $# -ne 2 ]; then
echo "###############################"
echo "Missing one or more parameters!"
echo "###############################"
  help_message
  exit 1
fi

# Check if first parameter is an existing folder
if [ ! -d "$1" ]; then
  echo "################################"
  echo "The directory $1 does not exist."
  echo "################################"
  help_message
  exit 1
else
  folder_to_archive=$1
fi

# Check if second parameter is a non-existing file
if [ -f "$2" ]; then
  echo "###########################"
  echo "The file $2 already exists."
  echo "###########################"
  help_message
  exit 1
else
  archive_file=$2
fi

# Create an archive file from received parameters
tar -czf "$archive_file" "$folder_to_archive"

echo "The archive successfully created!"

exit 0