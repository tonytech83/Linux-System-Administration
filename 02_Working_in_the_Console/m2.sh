#!/bin/bash

#
# Homework Check Script 
# for LSA 2021.11+ / M2
# 

if [ $(id -u) != 0 ]; then
  echo 'This script must be run as root (or with sudo). Exiting ...'
  exit 1
fi

app=''

#if [ -n $app ]; then
if [ x$app == 'x' ]; then
  curl --help &> /dev/null
  if [ $? -eq 0 ]; then app='curl'; fi
fi

#if [ -n $app ]; then
if [ x$app == 'x' ]; then
  wget --help &> /dev/null
  if [ $? -eq 0 ]; then app='wget'; fi
fi

if [ ! "$app" ]; then
  echo 'Neither curl nor wget found. Exiting ...'
  exit 1
fi

distro=other

grep -i rhel /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=RHEL; fi

grep -i suse /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=SUSE; fi

grep -i debian /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=Debian; fi

echo "* Working on $distro-based machine"

echo '{' > /tmp/hw.log

echo "\"date\": \"$(date '+%Y-%m-%d %H:%M:%S')\"," >> /tmp/hw.log

echo "\"family\": \"$distro\"," >> /tmp/hw.log

echo "\"distribution\": $(grep PRETTY_NAME /etc/os-release | cut -d = -f 2), " >> /tmp/hw.log

echo "\"module\": 2," >> /tmp/hw.log

echo "\"tests\": [" >> /tmp/hw.log


tt='Testing for the developer and manager users'
to=0
echo '* '$tt' ...'
cat /etc/passwd | grep developer | grep 'ProjectX Developer' &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
cat /etc/shadow | grep developer | grep '!!' &> /dev/null
if [ $? -eq 0 ]; then to=$((to+1)); fi
cat /etc/passwd | grep manager | grep 'ProjectX Manager' &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
cat /etc/shadow | grep manager | grep '!!' &> /dev/null
if [ $? -eq 0 ]; then to=$((to+1)); fi
if [ $to -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 1, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the projectxyz group'
echo '* '$tt' ...'
cat /etc/group | grep projectxyz | grep 3000 &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 2, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the projectxyz group members (developer and manager)'
echo '* '$tt' ...'
cat /etc/group | grep projectxyz | grep developer | grep manager &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 3, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the /shared/projects folder'
echo '* '$tt' ...'
ls /shared/projects &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 4, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the projectXYZ hierarchy of folders'
echo '* '$tt' ...'
ls -al /shared/projects/projectXYZ/Stage{1..3}/{DOCUMENTS,BUDGET} &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 5, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the documentN.doc set of files'
echo '* '$tt' ...'
ls -l /shared/projects/projectXYZ/Stage{1..3}/DOCUMENTS/document{1..5}.doc &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 6, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the readme_NN.txt set of files'
echo '* '$tt' ...'
ls -l /shared/projects/projectXYZ/Stage{1..3}/BUDGET/readme_{bg,de,en}.txt &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 7, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the user ownership of the projectXYZ folder and files'
to=0
echo '* '$tt' ...'
ls -l /shared/projects/projectXYZ | grep manager &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ/Stage3 | grep manager &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ/Stage3/BUDGET | grep manager &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ/Stage3/BUDGET/readme_bg.txt | grep manager &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
if [ $to -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 8, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the group ownership of the projectXYZ folder and files'
to=0
echo '* '$tt' ...'
ls -l /shared/projects/projectXYZ | grep projectxyz &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ/Stage3 | grep projectxyz &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ/Stage3/BUDGET | grep projectxyz &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ/Stage3/BUDGET/readme_bg.txt | grep projectxyz &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
if [ $to -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 9, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for permissions of the folders'
to=0
echo '* '$tt' ...'
ls -l /shared/projects | grep projectXYZ | grep drwxrws--- &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ | grep Stage3 | grep drwxrws--- &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
ls -l /shared/projects/projectXYZ/Stage3 | grep BUDGET | grep drwxrws--- &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
if [ $to -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 10, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for permissions of the files'
echo '* '$tt' ...'
if [ $(ls -l /shared/projects/projectXYZ/Stage{1..3}/{BUDGET,DOCUMENTS} | grep -- -rw-rw---- | wc -l) -ge 24 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 11, \"name\": \"$tt\", \"result\": \"$tr\"}" >> /tmp/hw.log


echo "]" >> /tmp/hw.log

echo '}' >> /tmp/hw.log

if [ $app == 'curl' ]; then
  curl --request POST --url https://courses.zahariev.pro/ --header 'content-type: application/json' --data @/tmp/hw.log
else
  wget --quiet --method POST --header 'content-type: application/json' --body-file=/tmp/hw.log --output-document - https://courses.zahariev.pro/
fi
