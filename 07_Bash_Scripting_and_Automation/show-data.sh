#!/bin/bash
#
# Script showing data from /tmp/user-data.sh
#

# checking if the user supplied a file path
if [ $# -ne 1 ]; then
  echo "Mising one argument!";
  echo "Usage: $0 file_path/file_name"
  exit 1;
fi

# set variables
row_num=1
filename=$1

# iterates through lines in file and print to console the information in special format
for line in $(cat $filename); do
  echo "Row #$row_num: $line"
  row_num=$((row_num + 1))
done

exit 0