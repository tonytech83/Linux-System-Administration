#!/bin/bash

#
# Homework Check Script 
# for LSA 2021.11+ / M1
#

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

echo "* Working on $distro-based machine (using $app to report)"

echo '{' > /tmp/hw.log

echo "\"date\": \"$(date '+%Y-%m-%d %H:%M:%S')\"," >> /tmp/hw.log

echo "\"family\": \"$distro\"," >> /tmp/hw.log

echo "\"distribution\": $(grep PRETTY_NAME /etc/os-release | cut -d = -f 2), " >> /tmp/hw.log

echo "\"module\": 1," >> /tmp/hw.log

echo "\"tests\": [" >> /tmp/hw.log

tt='Testing for a desktop environment installed and in use'
echo '* '$tt' ...'
tf=$XDG_CURRENT_DESKTOP
echo $tf | grep -i -E 'cinnamon|gnome|kde|lxde|lxqt|mate|xfce' &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 1, \"name\": \"$tt\", \"found\": \"$tf\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for a host named after the distribution'
echo '* '$tt' ...'
tf=$(hostname -s)
grep $tf /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 2, \"name\": \"$tt\", \"found\": \"$tf\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the domain name of the host'
echo '* '$tt' ...'
tf=$(hostname)
echo $tf | grep lsa.lab &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 3, \"name\": \"$tt\", \"found\": \"$tf\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for a regular user #1'
echo '* '$tt' ...'
tf=$(id -u)
if [ $(id -u) -ge 1000 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 4, \"name\": \"$tt\", \"found\": \"$tf\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for a regular user #2'
echo '* '$tt' ...'
tf=$USER 
cut -d : -f 5 /etc/passwd | grep -i $USER &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 5, \"name\": \"$tt\", \"found\": \"$tf\", \"result\": \"$tr\"}" >> /tmp/hw.log

echo "]" >> /tmp/hw.log

echo '}' >> /tmp/hw.log

if [ $app == 'curl' ]; then
  curl --request POST --url https://courses.zahariev.pro/ --header 'content-type: application/json' --data @/tmp/hw.log
else
  wget --quiet --method POST --header 'content-type: application/json' --body-file=/tmp/hw.log --output-document - https://courses.zahariev.pro/
fi
