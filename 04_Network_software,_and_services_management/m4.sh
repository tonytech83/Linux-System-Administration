#!/bin/bash

#
# Homework Check Script 
# for LSA 2021.11+ / M4
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

function check_vm1 {

distro=other

grep -i rhel /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=RHEL; fi

grep -i suse /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=SUSE; fi

grep -i debian /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=Debian; fi

echo "* Working on $distro-based machine (VM1)"

echo '{' > /tmp/hw.log

echo "\"date\": \"$(date '+%Y-%m-%d %H:%M:%S')\"," >> /tmp/hw.log

echo "\"vm\": 1, " >> /tmp/hw.log

echo "\"family\": \"$distro\"," >> /tmp/hw.log

echo "\"distribution\": $(grep PRETTY_NAME /etc/os-release | cut -d = -f 2), " >> /tmp/hw.log

echo "\"module\": 4," >> /tmp/hw.log

echo "\"tests\": [" >> /tmp/hw.log

tt='Testing if the 192.168.148.1 IP address is set'
echo '* '$tt' ...'
ip a | grep 192.168.148.1 &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 1, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for DHCP server installed and running'
tf='dhcpd'
if [ $distro == 'RHEL' ]; then tf='dhcpd'; fi
if [ $distro == 'SUSE' ]; then tf='dhcpd'; fi
if [ $distro == 'Debian' ]; then tf='isc-dhcp-server'; fi
echo '* '$tt" ($tf) ..."
systemctl is-active --quiet $tf &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 2, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing the DHCP configuration'
tf='/etc/dhcp/dhcpd.conf'
if [ $distro == 'RHEL' ]; then tf='/etc/dhcp/dhcpd.conf'; fi
if [ $distro == 'SUSE' ]; then tf='/etc/dhcpd.conf'; fi
if [ $distro == 'Debian' ]; then tf='/etc/dhcp/dhcpd.conf'; fi
echo '* '$tt" ($tf) ..."
grep 8.8.8.8 $tf &> /dev/null && grep 192.168.148.0 $tf &> /dev/null && grep 192.168.148.50 $tf &> /dev/null && grep 192.168.148.59 $tf &> /dev/null && grep 192.168.148.1 $tf &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 3, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for SSH server installed and running'
echo '* '$tt' ...' 
systemctl is-active --quiet sshd &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 4, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing if the firewall is running'
tf='firewalld'
if [ $distro == 'RHEL' ]; then tf='firewalld'; fi
if [ $distro == 'SUSE' ]; then tf='firewalld'; fi
if [ $distro == 'Debian' ]; then tf='ufw'; fi
echo '* '$tt" ($tf) ..."
if [ $distro == 'Debian' ]; then
	ufw status | grep -i -v inactive &> /dev/null
else
	systemctl is-active --quiet $tf &> /dev/null
fi
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 5, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing if the SSH (22/tcp) is allowed in the firewall'
echo '* '$tt' ...'
if [ $distro == 'Debian' ]; then
	(ufw status | grep 22 &> /dev/null) || (ufw status | grep -i ssh &> /dev/null)
else
	(firewall-cmd --list-ports | grep 22 &> /dev/null) || (firewall-cmd --list-services | grep -i ssh &> /dev/null)
fi
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 6, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing if IP forwarding is enabled'
echo '* '$tt' ...'
grep 1 /proc/sys/net/ipv4/ip_forward &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 7, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing if repos.zahariev.pro is registered'
echo '* '$tt' ...'
tf=$(mktemp --directory)
if [ $distro == 'RHEL' ]; then cp /etc/yum.repos.d/* $tf &> /dev/null ; fi
if [ $distro == 'SUSE' ]; then cp /etc/zypp/repos.d/* $tf &> /dev/null ; fi
if [ $distro == 'Debian' ]; then cp /etc/apt/sources.list $tf &> /dev/null && cp /etc/apt/sources.list.d/* $tf &> /dev/null || true ; fi
grep zahariev $tf/* &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 8, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log
rm -rf $tf


tt='Testing if hello-lsa is installed'
echo '* '$tt' ...'
hello-lsa &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 9, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing if the second station got an address via DHCP'
tf='/var/lib/dhcpd/dhcpd.leases'
tc=0
ta='192.168.148.1'
if [ $distro == 'RHEL' ]; then tf='/var/lib/dhcpd/dhcpd.leases'; fi
if [ $distro == 'SUSE' ]; then tf='/var/lib/dhcp/db/dhcpd.leases'; fi
if [ $distro == 'Debian' ]; then tf='/var/lib/dhcp/dhcpd.leases'; fi
echo '* '$tt' ...'
for i in $(grep ^lease $tf | cut -d ' ' -f 2); do
	ping -c 1 $i &> /dev/null
	if [ $? -eq 0 ]; then ((tc=$tc+1)); ta=$i; fi
done
if [ $tc -gt 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 10, \"name\": \"$tt\", \"result\": \"$tr\"} " >> /tmp/hw.log

echo "]" >> /tmp/hw.log

echo '}' >> /tmp/hw.log
}

function check_vm2 {

distro=other

grep -i rhel /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=RHEL; fi

grep -i suse /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=SUSE; fi

grep -i debian /etc/os-release &> /dev/null
if [ $? -eq 0 ]; then distro=Debian; fi

echo "* Working on $distro-based machine (VM2)"

echo '{' > /tmp/hw.log

echo "\"date\": \"$(date '+%Y-%m-%d %H:%M:%S')\"," >> /tmp/hw.log

echo "\"vm\": 2, " >> /tmp/hw.log

echo "\"family\": \"$distro\"," >> /tmp/hw.log

echo "\"distribution\": $(grep PRETTY_NAME /etc/os-release | cut -d = -f 2), " >> /tmp/hw.log

echo "\"module\": 4," >> /tmp/hw.log

echo "\"tests\": [" >> /tmp/hw.log

tt='Testing if the second station got an address in the right network'
echo '* '$tt' ...'
ip a | grep 192.168.148 &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 1, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if there is a homework user'
echo '* '$tt' ...'
grep homework /etc/passwd &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 2, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if the homework user has the correct password'
tf='xyz'
echo '* '$tt' ...'
grep homework /etc/passwd &> /dev/null
if [ $? -eq 0 ]; then
	te=$(grep homework /etc/shadow | cut -d : -f 2 | cut -d $ -f 2)
	# expecting y in recent Debian/Ubuntu or 6 for others
	if [ $te == 'y' ]; then
		tf=$(grep homework /etc/shadow | cut -d : -f 2 | cut -d $ -f 4)
		tp=$(perl -e 'print crypt "Parolka3", "\$y\$j9T\$'$(echo $tf)'\$"' 2> /dev/null)
	else 
		tf=$(grep homework /etc/shadow | cut -d : -f 2 | cut -d $ -f 3)
		tp=$(openssl passwd -6 -salt $tf Parolka3)
	fi
fi
grep homework /etc/shadow | grep $tp &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 3, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing if the homework user is sudoer'
echo '* '$tt' ...'
tf='wheel'
if [ $distro == 'Debian' ]; then tf='sudo'; fi
id homework | grep $tf &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 4, \"name\": \"$tt\", \"result\": \"$tr\"}, " >> /tmp/hw.log


tt='Testing for SSH server installed and running'
echo '* '$tt' ...'
systemctl is-active --quiet sshd &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 5, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing for SSH server running on 50022'
echo '* '$tt' ...'
grep Port /etc/ssh/sshd_config | grep 50022 &> /dev/null
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 6, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing if the firewall is running'
tf='firewalld'
if [ $distro == 'RHEL' ]; then tf='firewalld'; fi
if [ $distro == 'SUSE' ]; then tf='firewalld'; fi
if [ $distro == 'Debian' ]; then tf='ufw'; fi
echo '* '$tt" ($tf) ..."
if [ $distro == 'Debian' ]; then
	ufw status | grep -i -v inactive &> /dev/null
else
	systemctl is-active --quiet $tf &> /dev/null
fi
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 7, \"name\": \"$tt\", \"result\": \"$tr\"}," >> /tmp/hw.log


tt='Testing if the SSH (50022/tcp) is allowed in the firewall'
echo '* '$tt' ...'
if [ $distro == 'Debian' ]; then
	ufw status | grep 50022 &> /dev/null 
else
	firewall-cmd --list-ports | grep 50022 &> /dev/null
fi
if [ $? -eq 0 ]; then tr='PASS'; else tr='ERROR'; fi
echo '... '$tr
echo "{\"id\": 8, \"name\": \"$tt\", \"result\": \"$tr\"}" >> /tmp/hw.log


echo "]" >> /tmp/hw.log

echo '}' >> /tmp/hw.log
}

if [ ${vm:-0} -ne 1 ] && [ ${vm:-0} -ne 2 ]; then
	echo -e 'ERROR: Not a valid choice. You must enter either 1 or 2.\n'
	echo -e 'For VM1 execute: \ncurl -s https://courses.zahariev.pro/m4.sh | sudo vm=1 bash\n'
	echo -e 'For VM2 execute: \ncurl -s https://courses.zahariev.pro/m4.sh | sudo vm=2 bash\n'
	exit 1
fi

if [ $vm -eq 1 ]; then
	check_vm1
fi

if [ $vm -eq 2 ]; then
	check_vm2
fi


if [ $app == 'curl' ]; then
  curl --request POST --url https://courses.zahariev.pro/ --header 'content-type: application/json' --data @/tmp/hw.log
else
  wget --quiet --method POST --header 'content-type: application/json' --body-file=/tmp/hw.log --output-document - https://courses.zahariev.pro/
fi
