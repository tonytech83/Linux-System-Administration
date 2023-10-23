#!/bin/bash

#
# Homework Check Script 
# for LSA 2021.11 / M7
# 

# Prerequsites
if [ -n $app ]; then 
  curl --help &> /dev/null 
  if [ $? -eq 0 ]; then app='curl'; fi
fi

if [ -n $app ]; then 
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

fware=BIOS

ls -al /sys/firmware/efi/ &> /dev/null
if [ $? -eq 0 ]; then fware=UEFI; fi

echo "* Working on $distro-based machine ($fware)"

echo '{' > /tmp/hw.log

echo "\"date\": \"$(date '+%Y-%m-%d %H:%M:%S')\"," >> /tmp/hw.log

echo "\"vm\": 1, " >> /tmp/hw.log

echo "\"fware\": \"$fware\"," >> /tmp/hw.log

echo "\"family\": \"$distro\"," >> /tmp/hw.log

echo "\"distribution\": $(grep PRETTY_NAME /etc/os-release | cut -d = -f 2), " >> /tmp/hw.log

echo "\"module\": 7," >> /tmp/hw.log

echo "\"tests\": [" >> /tmp/hw.log

tt='Testing if ~/user-data.sh file exists and is executable'
echo '* '$tt' ...'
[ -x /home/$tu/user-data.sh ] 
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 1, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/user-data.sh file has the required parts'
echo '* '$tt' ...'
grep '#!/bin/bash' /home/$tu/user-data.sh &> /dev/null && grep 'echo' /home/$tu/user-data.sh &> /dev/null && grep 'read' /home/$tu/user-data.sh &> /dev/null && grep 'user-data.dat' /home/$tu/user-data.sh &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 2, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/user-data.sh file is working as expected'
echo '* '$tt' ...'
echo -e 'Dimitar\n Zahariev\n Provadia\n' | /home/$tu/user-data.sh &> /dev/null && tail -n 1 /tmp/user-data.dat 2> /dev/null | grep 'Provadia' &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR ('$?')'; fi
echo '... '$tr
echo "{\"id\": 3, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/user-data.sh has been executed at least 3 times'
echo '* '$tt' ...'
[ $(wc -l /tmp/user-data.dat | cut -d ' ' -f 1) -ge 3 ]
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 4, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/show-data.sh file exists and is executable'
echo '* '$tt' ...'
[ -x /home/$tu/show-data.sh ]
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 5, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/show-data.sh file has the required parts'
echo '* '$tt' ...'
grep '#!/bin/bash' /home/$tu/show-data.sh &> /dev/null && grep 'echo' /home/$tu/show-data.sh &> /dev/null && grep 'exit' /home/$tu/show-data.sh &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 6, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/show-data.sh file is working as expected #1 (with params)'
echo '* '$tt' ...'
tc=$(wc -l /tmp/user-data.dat | cut -d ' ' -f 1)
#/home/$tu/show-data.sh /tmp/user-data.dat 2> /dev/null | tail -n 1 | grep 'Row #'$tc | grep Provadia &> /dev/null
/home/$tu/show-data.sh /tmp/user-data.dat 2> /dev/null | tail -n 1 | grep 'Row #'$tc &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 7, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/show-data.sh file is working as expected #2 (no params)'
echo '* '$tt' ...'
/home/$tu/show-data.sh &> /dev/null
if [ $? -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 8, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/archiver.sh file exists and is executable'
echo '* '$tt' ...'
[ -x /home/$tu/archiver.sh ]
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 9, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/archiver.sh file has the required parts'
echo '* '$tt' ...'
grep '#!/bin/bash' /home/$tu/archiver.sh &> /dev/null && grep 'echo' /home/$tu/archiver.sh &> /dev/null && grep 'exit' /home/$tu/archiver.sh &> /dev/null  && grep 'tar' /home/$tu/archiver.sh &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 10, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/archiver.sh file is working as expected #1 (no params)'
echo '* '$tt' ...'
if [ -x /home/$tu/archiver.sh ]; then
   /home/$tu/archiver.sh &> /dev/null
   if [ $? -ne 0 ]; then tr='PASS'; else tr='ERROR'; fi
else
   tr='ERROR';
fi
echo '... '$tr
echo "{\"id\": 11, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


t1=$(mktemp)
t2=$(mktemp -du)


tt='Testing if ~/archiver.sh file is working as expected #2 (one param - exising file)'
echo '* '$tt' ...'
if [ -x /home/$tu/archiver.sh ]; then
   /home/$tu/archiver.sh $t1 &> /dev/null
   if [ $? -ne 0 ]; then tr='PASS'; else tr='ERROR'; fi
else
   tr='ERROR';
fi
echo '... '$tr
echo "{\"id\": 12, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if ~/archiver.sh file is working as expected #3 (one param - non existing dir)'
echo '* '$tt' ...'
if [ -x /home/$tu/archiver.sh ]; then
   /home/$tu/archiver.sh $t2 &> /dev/null
   if [ $? -ne 0 ]; then tr='PASS'; else tr='ERROR'; fi
else
   tr='ERROR';
fi
echo '... '$tr
echo "{\"id\": 13, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


mkdir $t2 &> /dev/null
tt='Testing if ~/archiver.sh file is working as expected #4 (two params - existing file)'
echo '* '$tt' ...'
if [ -x /home/$tu/archiver.sh ]; then
   /home/$tu/archiver.sh $t2 $t1 &> /dev/null
   if [ $? -ne 0 ]; then tr='PASS'; else tr='ERROR'; fi
else
   tr='ERROR';
fi
echo '... '$tr
echo "{\"id\": 14, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


mkdir $t2 &> /dev/null
tt='Testing if ~/archiver.sh file is working as expected #5 (two params - correct)'
echo '* '$tt' ...'
/home/$tu/archiver.sh $t2 $t1.tgz &> /dev/null && ls -al $t1.tgz &> /dev/null && file $t1.tgz 2> /dev/null | grep gzip &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 15, \"name\": \"$tt\", \"result\": \"$tr\"} " >> /tmp/hw.log

rm -rf $t2 || true
rm -f $t1 || true

echo "]" >> /tmp/hw.log

echo '}' >> /tmp/hw.log

if [ $app == 'curl' ]; then
  curl --request POST --url https://courses.zahariev.pro/ --header 'content-type: application/json' --data @/tmp/hw.log
else
  wget --quiet --method POST --header 'content-type: application/json' --body-file=/tmp/hw.log --output-document - https://courses.zahariev.pro/
fi
