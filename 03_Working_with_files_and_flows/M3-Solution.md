### 1.	Make a local copy of the **/etc/services** file with the same name

```bash
cp -v /etc/services .
'/etc/services' -> './services'
```

### 2.	Using command line tools, create a variant of the local **services** file containing only the **comment lines** (lines starting with **#** symbol) and save it under the name **services_comments.txt**. For example:

```bash
cat services | grep '^#' > services_comments.txt
```

### 3.	Using command line tools, create another variant of the local **services** file containing everything but the **comment lines** (empty lines could be either present or absent in the resulting file) and save it under the name **services_wo_comments.txt**

```bash
cat services | grep -v '^#' > services_wo_comments.txt
```

### 4.	Using command line tools, create third variant of the local **services** file without comment lines and containing only information about **udp** services and save it under the name **services_udp.txt**
```bash
cat services | grep -v '^#' | grep 'udp' > services_udp.txt
```


### 5.	Open the file **services_wo_comments.txt** in vi editor

```bash
vi services_wo_comments.txt
```

### 6.	Find the line about **blackjack** service for **CentOS** and **openSUSE**, or **socks** for **Ubuntu**

```plain
/socks
```
 
### 7.	Delete **everything** from **this line to the end of the file**
-	From previous point click ESC to go back in Normal mode

```plain
:.,$d
```

### 8.	Save the result as **new file** under the name **well-known-ports.txt**

```plain
:w well-known-ports.txt
```
 
### 9.	Quit **vi** without saving the changes to the original file

```plain
:q!
```

### 10.	Using command line tools, substitute the symbol **/** with - symbol for the **first 100 lines** in the **well-known-ports.txt** file and store the result as **100-well-known-ports.txt**

```bash
sed 's/\//-/g' well-known-ports.txt | head -n 100 > 100-well-known-ports.txt
```

### 11.	Create (either using an editor or heredoc) a document named **doc1.txt** with the following content:

- **10-IT-HQ**
- **20-Accounting-HQ**
- **30-Help Desk-Remote**
- **40-Sales-HQ**

```bash
cat > doc1.txt << EOF
> 10-IT-HQ
> 20-Accounting-HQ
> 30-Help Desk-Remote
> 40-Sales-HQ
> EOF
```

### 12.	Create (either using an editor or heredoc) second document named **doc2.txt** with the following content:
- **10-B.Thomas**
- **20-J.Foster**
- **30-G.Smith**
- **40-F.Hudson**

```bash
cat > doc2.txt << ALABALA
> 10-B.Thomas
> 20-J.Foster
> 30-G.Smith
> 40-F.Hudson
> ALABALA
```

### 13.	Join the **doc1.txt** and **doc2.txt** files in a resulting file named **doc3.txt** (it should contain the **combined information** from the other two – in fact it will show **who is working where**)

```bash
join -t "-" -j 1 -a 1 doc1.txt doc2.txt > doc3.txt
```

### 14.	Enter set of commands to extract the **unique values** from the **third** field of **doc3.txt** file and store them in **locations.txt** file

```bash
cut -d '-' -f 3 doc3.txt | sort -u > locations.txt
```

### 15.	**Extend** the **previous** command in order to **count the unique values** and **store** the result to the **locations-count.txt** file

```bash
cut -d '-' -f 3 doc3.txt | sort -u | wc -l > locations-count.txt
```

### 16.	Find **all** files in **/etc** and its **sub-directories** with **size less than 200 bytes** and store their **sorted list** (containing just the path to the file and its name) in **small-etc-files.txt** file

```bash
sudo find /etc -type f -size -200c | sort > small-etc-files.txt
```