<h1 align="center"> AlmaLinux / Debian </h1>

## VM1 (Rila) - AlmaLinux


### 1.	Set one of the network cards with static IP 192.168.148.1/24 (and in the same virtual network as the only card of the other VM).

-	Create a new connection on interface name ens265.
```bash
sudo nmcli connection add type ethernet ifname ens256 con-name homework_m4
```
- Set static IP address on the new connection.
```bash
sudo nmcli connection modify homework_m4 ipv4.addresses 192.168.148.1/24 ipv4.method manual
```
- Force changes
```bash
sudo nmcli connection down homework_m4; sudo nmcli connection up homework_m4
```

### 2.	Install and configure DHCP with range from 192.168.148.50 – 192.168.148.59. Make sure that you pass the 8.8.8.8 DNS server as an option as well either on global or subnet level.

- Update repositories
```bash
sudo dnf update
```
- Install DHCP server
```bash
sudo dnf install dhcp-server
```
- Configure DHCP Server (subnet and options)
```bash
sudo nano /etc/dhcp/dhcpd.conf
```
```plain
option domain-name "lsa.lab";
option domain-name-servers 8.8.8.8;

subnet 192.168.148.0 netmask 255.255.255.0 {
  range 192.168.148.50 192.168.148.59;
  option routers 192.168.148.1;
  option broadcast-address 192.168.148.255;
  default-lease-time 600;
  max-lease-time 7200;
}
```
- Test new DHCP configuration
```bash
sudo dhcpd -t
```
- Start DHCP service
```bash
sudo systemctl start dhcpd
```
-	Made DHCP service to auto start
```bash
sudo systemctl enable dhcpd
```
- Check status of DHCP service
```bash
systemctl status dhcpd
```
### 3.	SSH service installed and running.

-	Install SSH server and client
```bash
sudo dnf install openssh-server openssh-clients
```
-	Start SSH server
```bash
sudo systemctl start sshd
```
-	Check whether the SSH server is running
```bash
sudo systemctl status sshd
```
### 4.	Firewall up and running, and allowing SSH connections.
- Check status of firewall
```bash
systemctl status firewall
```
-	Check SSH connections are allowed
```bash
sudo firewall-cmd --list-services
```
- If not allowed - add the port
```bash
sudo firewall-cmd --permanent --add-port=22/tcp
```
- Reload firewall configuration
```bash
sudo firewall-cmd –reload
```

### 5.	Enabled NAT and forwarding functionality, so the internal station can have access to Internet
-	Check firewall zones
```bash
sudo firewall-cmd --get-zones
```
-	Add VM NAT ethernet adapter in external zone
```bash
sudo nmcli connection modify ens160 connection.zone external
```
-	Add other VM ethernet adapter in trusted zone
```bash
sudo nmcli connection modify homework_m4 connection.zone trusted
```
-	Check active zones and connections
```bash
sudo nmcli connection modify homework_m4 connection.zone trusted
```
### 6.	Register the repos.zahariev.pro repository (check for details on https://repos.zahariev.pro)
```bash
sudo dnf config-manager --add-repo https://repos.zahariev.pro/dnf
```
### 7.	Install the hello-lsa package
```bash
sudo dnf install --nogpgcheck hello-lsa
```

## VM2 (Pirin) - Debian

### 1.	Make sure that the network adapter is set to get its IP address via DHCP
```bash
sudo cat /etc/network/interfaces
```
### 2.	Create a user homework with password Parolka3 and make it a sudoer (part of the admin, sudo, or wheel group, depending on you distribution)

-	Create new user
```bash
sudo adduser homework
```
-	Add user in sudoer
```bash
sudo usermod -aG sudo homework
```
-	Check the user (homework) groups
```bash
groups homework
```
### 3.	SSH service installed and running but on port 50022 instead of the default (22)
-	Edit SSH configuration, uncomment "Port 22" and change the port to 50022
```bash
sudo nano /etc/ssh/sshd_config
```
- Restart SSH service
```bash
sudo systemctl restart ssh
```
### 4.	Firewall up and running, and allowing SSH connections
- Install firewall (ufw)
```bash
sudo apt install ufw
```
-	Enable firewall (ufw)
```bash
sudo ufw enable
```
-	Allow new SSH port (50022/tcp)
```bash
sudo ufw allow 50022/tcp
```

<h1 align="center">Debian / OpenSUSE</h1>

## VM1 (Rila) - Debian
### 1.	Set one of the network cards with static IP 192.168.148.1/24 (and in the same virtual network as the only card of the other VM).
-	Change hostname
```bash
sudo hostnamectl set-hostname rila.lsa.lab
```
-	Add new hostname in /etc/hosts to prevent the displaying “unable to resolve host rila.lsa.lab: Name or service not known”
```bash
sudo nano /etc/hosts
```
```plain
127.0.0.1   localhost
127.0.0.1   rila.lsa.lab
127.0.1.1   debian
....
```
-	Edit interfaces file and add configuration for second network interface
```bash
sudo nano /etc/network/interfaces
```
```plain
...
# The second network interface
allow-hotplug ens35
iface ens35 inet static
address 192.168.148.1/24
...
```
-	Force the changes.
```bash
sudo ifdown ens35; sudo ifup ens35
```
### 2.	Install and configure DHCP with range from 192.168.148.50 – 192.168.148.59. Make sure that you pass the 8.8.8.8 DNS server as an option as well either on global or subnet level
-	Install DHCP Server
```bash
sudo apt install isc-dhcp-server
```
-	Configure DHCP Server
```bash
sudo nano /etc/dhcp/dhcpd.conf
```
```plain
option domain-name "lsa.lab";
option domain-name-servers 8.8.8.8;

subnet 192.168.148.0 netmask 255.255.255.0 {
  range 192.168.148.50 192.168.148.59;
  option routers 192.168.148.1;
  option broadcast-address 192.168.148.255;
  default-lease-time 600;
  max-lease-time 7200;
}
```
-	Test new configuration
```bash
sudo dhcpd -t
```
-	Set default adapter for DHCP server.
```bash
sudo nano /etc/default/isc-dhcp-server
```
```plain
...
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="ens35"
INTERFACESv6=""
```
-	Check DHCP service status.
```bash
sudo systemctl status isc-dhcp-server
```
### 3.	SSH service installed and running
```bash
sudo systemctl is-active ssh
```
### 4. Firewall up and running, and allowing SSH connections.
-	Install firewall (ufw).
```bash
sudo apt install ufw
```
-	Enable firewall.
```bash
sudo ufw enable
```
-	Allow SSH connections (22/tcp)
```bash
sudo ufw allow 22/tcp
```
### 5.	Enabled NAT and forwarding functionality, so the internal station can have access to Internet.
-	Change ufw configuration to allow forwarding (DEFAULT_FORWARD_POLICY=”ACCEPT”)
```bash
sudo nano /etc/default/ufw
```
-	Uncomment **net/ipv4/ip_forward=1** in **/etc/ufw/sysctl.conf**
```bash
sudo nano /etc/ufw/sysctl.conf
```
-	Add rule in **/etc/ufw/before.rules**
```bash
sudo nano /etc/ufw/before.rules
```
```plain
...
# NAT Table rules
*nat
:POSTROUTINGN ACCEPT [0:0]

# Forward traffic from ens35 (internal) through ens33 (external)
-A POSTROUTING -s 192.168.148.0/24 -o ens33 -j MASQUERADE
COMMIT
....
```
-	Reload firewall (ufw)
```bash
sudo ufw disable && sudo ufw enable
```
### 6.	Register the repos.zahariev.pro repository (check for details on https://repos.zahariev.pro)
```bash
echo "deb [arch=amd64] https://repos.zahariev.pro/apt stable main" | sudo tee /etc/apt/sources.list.d/zahariev-repo.list
```
### 7.	Install the hello-lsa package
```bash
sudo apt-get update --allow-insecure-repositories && sudo apt-get install hello-lsa
```
## VM2 (Pirin) – OpenSUSE
### 1.	Make sure that the network adapter is set to get its IP address via DHCP
```bash
sudo cat /etc/sysconfig/network/ifcfg-eth0
```
```plain
BOOTPROTO='dhcp'
STARTMODE='auto'
ZONE=public
```
### 2.	Create a user homework with password Parolka3 and make it a sudoer (part of the admin, sudo, or wheel group, depending on you distribution)
-	Create user
```bash
sudo useradd -m homework
```
-	Set password
```bash
sudo passwd homework
```
-	Add new user (homework) to **wheel**
```bash
sudo usermod -aG wheel homework
```
### 3.	SSH service installed and running but on port 50022 instead of the default (22)
-	Open /etc/ssh/sshd_config , uncomment row #Potr 22  and change port to 50022
```bash
sudo nano /etc/ssh/sshd_config
```
### 4.	Firewall up and running, and allowing SSH connections
-	Check the firewall
```bash
sudo systemctl status firewalld
```
-	Add firewall rule for new SSH port configuration
```bash
sudo firewall-cmd --permanent --add-port=50022/tcp
```
-	Reload firewall service.
```bash
sudo firewall-cmd --reload
```