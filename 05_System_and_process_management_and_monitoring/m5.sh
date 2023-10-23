#!/bin/bash

#
# Homework Check Script 
# for LSA 2021.11 / M5
# 

# Prerequsites
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

echo "\"module\": 5," >> /tmp/hw.log

echo "\"tests\": [" >> /tmp/hw.log


tt='Testing if GRUB timeout is set to 60'
echo '* '$tt' ...'
grep GRUB_TIMEOUT=60 /etc/default/grub &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 1, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if no quiet is appended to the Kernel command line'
echo '* '$tt' ...'
if [ $distro == 'RHEL' ]; then 
	grep GRUB_CMDLINE_LINUX /etc/default/grub | grep -v quiet &> /dev/null;
elif [ $distro == 'SUSE' ]; then 
	grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub | grep -v quiet &> /dev/null;
elif [ $distro == 'Debian' ]; then 
	grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub | grep -v quiet &> /dev/null; 
fi
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 2, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if the GRUB configuration changes were applied'
echo '* '$tt' ...'
find /boot -type f -name grub.cfg -exec cat {} \; | grep terminal_output -A 30 | grep timeout=60 &> /dev/null;
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 3, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing for the boot-extract.txt file'
echo '* '$tt' ...'
tail -n 5 /home/$tu/boot-extract.txt 2> /dev/null | grep '[  +0.000000]' 2> /dev/null | grep vmlinuz &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 4, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing for the After clause of the sshd.service'
echo '* '$tt' ...'
tf='/usr/lib/systemd/system/sshd.service'
if [ $distro == 'Debian' ]; then tf='/usr/lib/systemd/system/ssh.service'; fi
grep After $tf > /tmp/1.txt
diff /tmp/1.txt /home/$tu/sshd-after.txt &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 5, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log
rm /tmp/1.txt &> /dev/null || true


tt='Testing for the processes-tree.txt file'
echo '* '$tt' ...'
head -n 5 /home/$tu/processes-tree.txt 2> /dev/null | grep 'systemd(1)-+-' &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 6, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the free-space.txt file'
echo '* '$tt' ...'
head -n 1 /home/$tu/free-space.txt 2> /dev/null | grep '1GB-blocks' &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 7, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the used-space.txt file'
echo '* '$tt' ...'
du -d 1 -h / 2> /dev/null | sort -h -r | head -n 2 > /tmp/1.txt
head -n 2 /home/$tu/used-space.txt 1> /tmp/2.txt 2> /dev/null
diff /tmp/1.txt /tmp/2.txt &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 8, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log
rm /tmp/1.txt /tmp/2.txt &> /dev/null || true


tt='Testing for the stat-output.txt file'
echo '* '$tt' ...'
tf=0
tf=$(grep UID /home/$tu/stat-output.txt 2> /dev/null | wc -l)
if [ $tf -eq 6 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 9, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for the open-files.txt file'
echo '* '$tt' ...'
tp=0
#lsof +D /etc 1> /tmp/1.txt 2> /dev/null
#head -n -1 /home/$tu/open-files.txt > /tmp/2.txt 2> /dev/null
#diff /tmp/1.txt /tmp/2.txt &> /dev/null
#if [ $? -eq 0 ]; then tp=$((tp+1)); fi
grep 'lsof +D /etc' /home/$tu/open-files.txt &> /dev/null
if [ $? -eq 0 ]; then tp=$((tp+1)); fi
#if [ $tp -eq 2 ]; then tr='PASS'; else tr='ERROR'; fi
if [ $tp -eq 1 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 10, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log
#rm /tmp/1.txt /tmp/2.txt &> /dev/null || true


tt='Testing for the process-monitoring.txt file'
echo '* '$tt' ...'
tf=0
# changed on 2022.10.02
#tf=$(grep systemd-journal /home/$tu/process-monitoring.txt 2> /dev/null | wc -l)
tf=$(grep top /home/$tu/process-monitoring.txt 2> /dev/null | grep 'load average' | wc -l)
if [ $tf -eq 5 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 11, \"name\": \"$tt\", \"result\": \"$tr\"}" >> /tmp/hw.log

echo "]" >> /tmp/hw.log

echo '}' >> /tmp/hw.log

if [ $app == 'curl' ]; then
  curl --request POST --url https://courses.zahariev.pro/ --header 'content-type: application/json' --data @/tmp/hw.log
else
  wget --quiet --method POST --header 'content-type: application/json' --body-file=/tmp/hw.log --output-document - https://courses.zahariev.pro/
fi
