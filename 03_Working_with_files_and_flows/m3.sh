#!/bin/bash

#
# Homework Check Script 
# for LSA 2021.11+ / M3
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

tu=${SUDO_USER:-$USER}

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

echo "\"module\": 3," >> /tmp/hw.log

echo "\"tests\": [" >> /tmp/hw.log

# task 1
tt='Testing for a local copy of /etc/services'
to=0
echo '* '$tt' ...'
cat /home/$tu/services &> /dev/null
if [ $? -ne 0 ]; then to=$((to+1)); fi
if [ $to -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 1, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 2
tt='Checking the services_comments.txt file'
to=0
echo '* '$tt' ...'
tst1=$(grep -E '^[#]' /home/$tu/services 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/services_comments.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 2, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 3
tt='Checking the services_wo_comments.txt file'
to=0
# no empty lines allowed
echo '* '$tt' (no empty lines allowed) ...'
tst1=$(grep -E '^[^#]' /home/$tu/services 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/services_wo_comments.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
# empty lines allowed
echo '* '$tt' (empty lines allowed) ...'
tst1=$(grep -v ^# /home/$tu/services 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/services_wo_comments.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
# conclusion
if [ $to -ge 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 3, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 4
tt='Checking the services_udp.txt file'
to=0
echo '* '$tt' ...'
tst1=$(grep -E '^[^#]*udp' /home/$tu/services 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/services_udp.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 4, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 5
tt='Checking the well-known-ports.txt file'
to=0
echo '* '$tt' ...'
if [ -f /home/$tu/well-known-ports.txt ]; then to=$((to+1)); fi
grep -E '[^1080]' /home/$tu/well-known-ports.txt &> /dev/null
if [ $? -eq 0 ]; then to=$((to+1)); fi
if [ $to -eq 2 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 5, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 6
tt='Checking the 100-well-known-ports.txt file'
to=0
echo '* '$tt' ...'
tst1=$(sed -n '1,100s/\//-/pg' /home/$tu/well-known-ports.txt 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/100-well-known-ports.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 6, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 7
tt='Checking the doc1.txt file'
to=0
echo '* '$tt' ...'
tst1=794efe5a244ddc991af16f6735ccf735
tst2=$(md5sum /home/$tu/doc1.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 7, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 8
tt='Checking the doc2.txt file'
to=0
echo '* '$tt' ...'
tst1=63b5db67f1ff1ec0a058b04d123abf42
tst2=$(md5sum /home/$tu/doc2.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 8, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 9
tt='Checking the doc3.txt file'
to=0
echo '* '$tt' ...'
tst1=$(join -t - -j 1 /home/$tu/doc1.txt /home/$tu/doc2.txt 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/doc3.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 9, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 10
tt='Checking the locations.txt file'
to=0
echo '* '$tt' ...'
tst1=$(cut -d - -f 3 /home/$tu/doc3.txt | sort | uniq 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/locations.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 10, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 11
tt='Checking the locations-count.txt file'
to=0
echo '* '$tt' ...'
tst1=$(cut -d - -f 3 /home/$tu/doc3.txt | sort | uniq | wc -l 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/locations-count.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 11, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log

# task 12
tt='Checking the small-etc-files.txt file'
to=0
echo '* '$tt' ...'
tst1=$(find /etc -type f -size -200c -exec ls {} \; | sort 2> /dev/null | md5sum | cut -d ' ' -f 1)
tst2=$(md5sum /home/$tu/small-etc-files.txt 2> /dev/null | cut -d ' ' -f 1)
if [ ${tst1:-'xxx'} == ${tst2:-'yyy'} ]; then to=$((to+1)); fi
if [ $to -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 12, \"name\": \"$tt\", \"result\": \"$tr\"}" >> /tmp/hw.log

echo "]" >> /tmp/hw.log

echo '}' >> /tmp/hw.log

if [ $app == 'curl' ]; then
  curl --request POST --url https://courses.zahariev.pro/ --header 'content-type: application/json' --data @/tmp/hw.log
else
  wget --quiet --method POST --header 'content-type: application/json' --body-file=/tmp/hw.log --output-document - https://courses.zahariev.pro/
fi
