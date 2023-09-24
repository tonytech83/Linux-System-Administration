### 1. Create two users (developer and manager) with full names like ProjectX Developer and ProjectX Manager or similar format. Then set their passwords to whatever you like, for example Password2 and Password3

```bash
sudo useradd -m -c “ProjectX Developer” developer
sudo passwd developer
sudo useradd -m -c “ProjectX Manager” manager
sudo passwd manager
```

### 2. Create a new user group with ID 3000, named projectxyz

```bash
sudo groupadd -g 3000 projectxyz
```

### 3. Make both users (developer and manager) members of the projectxyz group

```bash
sudo usermod -aG projectxyz developer
sudo usermod -aG projectxyz manager
```

### 4.	Create a folder /shared/projects

```bash
sudo mkdir shared
sudo mkdir shared/projects
```

### 5.	Create series of folders under /shared/projects with the following structure:
 - projectXYZ
    - Stage1
      - DOCUMENTS
      - BUDGET
    - Stage2
      - DOCUMENTS
      - BUDGET
    - Stage3
      - DOCUMENTS
      - BUDGET

```bash
sudo mkdir shared/projects/projectXYZ
sudo mkdir Stage{1,2,3}
sudo mkdir Stage1/DOCUMENTS
sudo mkdir Stage2/DOCUMENTS
sudo mkdir Stage3/DOCUMENTS
sudo mkdir Stage1/BUDGET
sudo mkdir Stage2/BUDGET
sudo mkdir Stage3/BUDGET
```

### 6.	Create at least 5 files document1.doc through document5.doc in every DOCUMENTS folder

```bash
sudo touch Stage1/DOCUMENTS/document{1..5}.doc
sudo touch Stage2/DOCUMENTS/document{1..5}.doc
sudo touch Stage3/DOCUMENTS/document{1..5}.doc
```

### 7.	Create readme_en.txt, readme_bg.txt, and readme_de.txt files in every BUDGET folder

```bash
sudo touch Stage1/BUDGET/readme_{en,bg,de}.txt
sudo touch Stage2/BUDGET/readme_{en,bg,de}.txt
sudo touch Stage3/BUDGET/readme_{en,bg,de}.txt
```

### 8. Change the owner of the projectXYZ folder and all files and folders there to manager

```bash
sudo chown -R manager projectXYZ/
```

### 9.	Change the group owner of the projectXYZ folder and all files and folders there to projectxyz

```bash
sudo chgrp -R projectxyz projectXYZ
```

### 10.	Change the permissions of the projectXYZ folder and all subfolders (not the files, just the folders) to be read, write and execute for the owner and the group and no permissions for everyone else. Adjust the permissions of all folders in such a way, so all new files made by either the developer or the manager user will be owned by the projectxyz group

```bash
sudo find /shared/projects/projectXYZ/ -type d -exec chmod 770 {} +
sudo chmod -R g+s projectXYZ/
```

### 11. Set permissions for all files under the above folder structure (projectXYZ) to read and write for the owner and the group and no permissions for everyone else

```bash
sudo find /shared/projects/projectXYZ/ -type f -exec chmod 660 {} +
```