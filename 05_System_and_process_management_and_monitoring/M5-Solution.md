<h1 align="center"> AlmaLinux / Debian </h1>

## VM1 (Rila) - AlmaLinux


### 1. Make the following permanent changes in the boot procedure of your system of choice:

-	Open grub file with text editor:
```bash
sudo nano /etc/default/grub
```
- Set waiting time to be 1 minute
```plain
Change from GRUB_TIMEOUT=5 to GRUB_TIMEOUT=60
```
- Instruct the loader to show all diagnostic messages during boot.
```plain
Change from GRUB_CMDLINE_LINUX_DEFAULT="quiet" to GRUB_CMDLINE_LINUX_DEFAULT=""
```
- Publish the changes
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
or
```bash
sudo update-grub
```

### 2. After the boot, save the contents of the kernel ring buffer in human readable format ordered from the latest to the earliest to a file named boot-extract.txt

```bash
sudo dmesg -H | tac > boot-extract.txt
```

### 3. Extract the After clause of the sshd.service unit and save it to sshd-after.txt file

```bash
systemctl cat ssh.service | grep "After=" > sshd-after.txt
```

### 4. Using the **pstree** command, create a tree of all processes on your system with their PIDs and store it to a file processes-tree.txt 

-	If pstree not installed on the system, we should search for it in our registered repositories:
```bash
sudo apt search pstree
```

-	The command is part of psmisc package, and it should be installed.
```bash
sudo apt install psmisc
```

-	All processes with PIDs to file
```bash
sudo pstree -p > processes-tree.txt
```

### 5. Using the df command, show the free space in GB and save the result in file named free-space.txt

```bash
df -BGB > free-space.txt
```

### 6. Check how much space are consuming the folders in the / but focus only on the first level. Extract the data in human readable format ordered from the largest to the smallest consumer and save it to file used-space.txt

```bash
sudo du -h -d 1 / | sort -rh > used-space.txt
```

### 7. Using the **pidstat** command, collect 5 measurements with a pause of 5 seconds between two iterations, and store the result in file named stat-output.txt

-	If pidstat not installed on the system, we should search for it in our registered repositories:
```bash
sudo apt search pidstat
```

-	The command is part of sysstat package, and it should be installed.
```bash
sudo apt install sysstat
```

-	Collect measurements.
```bash
pidstat 5 5 > stat-output.txt
```

### 8. Save the list of open files in your /etc folder to a file open-files.txt. Append the command you used at the end of the open-files.txt file.

```bash
sudo lsof +D /etc > open-files.txt
echo "sudo lsof +D /etc > open-files.txt" >> open-files.txt
```

### 9. Using the top command, collect 5 measurements with a pause of 5 seconds between two iterations of all running processes on the system and save them to a file process-monitoring.txt

```bash
top -n 5 -d 5 > process-monitoring.txt
```