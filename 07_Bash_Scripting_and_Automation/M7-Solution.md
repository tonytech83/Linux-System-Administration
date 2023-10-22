<h1 align="center">Bash Scripting and Automation</h1>

<h3>1. Create a script named user-data.sh that when started will ask the user for (without the a.,b.,c.). Then it will append the collected data to a file /tmp/user-data.dat. For example, if the user input is (without the a.,b.,c.). The script will store John;Smith;London in the file for example.</h3>

```bash
#!/bin/bash

#
# Script asking user for First name, Last name and Plase of birth
# and store data in /tmp/user-data.dat
#

# read First name from console and store data in  variable first_name
read -p 'Enter your First name: ' first_name

# read Last name from console and store data in variable last_name
read -p 'Enter your Last name: ' last_name

# read Plase of birth from console and store data in variable birth_place
read -p 'Enter your Place of birth: ' birth_place

# store cancated information with separator ';' into file /tmp/user-data.dat
echo "$first_name;$last_name;$birth_place" >> /tmp/user-data.dat
```

<h3>2. Execute the script several times (3 to 5) with different answers each time</h3>

```shell
user@debian:~$ sudo ./user-data.sh
Enter your First name: First
Enter your Last name: Last
Enter your Place of birth: Place
```

<h3>3. Create a script named show-data.sh that when started with a parameter a file name (the one from the previous exercise) will display the information from it in the following format:</h3>

- Row #1: John;Smith;London
- Row #2: Jane;Hudson;Manchester
- …

If executed without parameters or with incorrect number of parameters to display help message and quit.

```bash
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
```

<h3>4. Create a script named archiver.sh that will accept two parameters on the command line (Folder to archive and Name (and path) of the archive). When executed with the two parameters to create a tar+gz archive. If executed with incorrect number of parameters or their values are incorrect (parameters should follow the rules):</h3>

- First parameter should be always an existing folder
- Second parameter should be non-existing file

To display help message and to exit.

```bash
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
```