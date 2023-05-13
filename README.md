# 111-2Course-Network-Adminstration

## hw2.sh
shell script for hw2 of Network Adminstration in NCKU.
## Homework 3 - Log & File Maintenance
### Add three 1GB disks 新增三個1GB的硬碟
To get the name of the hard disk we added, let's first take a screenshot after giving command `ls /dev`. After that, shut down your VM with `shutdown`, and turn the VM down by VMware.
> VMware Steps below: 
>   1) Press `Add` under `Hardware`
>   2) New a Hard Disk
>   3) Select the type of the new hard disk. (SCSI recommended by VMware though)
>   4) Select `Create a new virtual disk` if you haven't new a disk yet
>   5) Set the size of the disk to 1 GB

為了知道新增的硬碟叫什麼名字，先`ls /dev`然後把印出來的內容截圖起來。接著用`shutdown`把VM關機以後再用VMware shutdown機器。<br>
打開VM設定，新增三顆大小為1GB的虛擬硬碟。
> VMware的步驟如下 : 
>   1) 在Hardware底下按Add按鈕
>   2) 新增一個硬碟
>   3) 選擇硬碟的種類 (VMWare預設建議用SCSI)
>   4) 選擇 `Create a new virtual disk`，如果是已經新增好了也可以選擇`Using an existing disk`
>   5) 將大小設定為1GB

### Create Pool
Create a ZFS RAID-Z pool named `sa_pool` and three 1G disks as devices.<br>
`sudo zpool create sa_pool raidz /dev/da1 /dev/da2 /dev/da3`
### Create Dataset
Make a new ﬁle system called `data` in pool `sa_pool`, set the following properties `compression=lz4`, `copies=2`, `atime=off` and mount it at `/sa_data`.<br>
`sudo zfs create -o compression=lz4 atime=off copies=2 mountpoint=/sa_data sa_pool/data`<br><br>
Also, we can change the properties after create the dataset by using `zfs set`.<br>
`sudo zfs create sa_pool/data`<br>
`sudo zfs set compression=lz4 atime=off copies=2 mountpoint=/sa_data sa_pool/data`<br><br>
We can use `sudo zfs get all sa_pool/data | less` to check the properties.<br>
### Change directory owner and group
commands : <br>
- `chown`(8) -- change user owner
- `chgrp`(1) -- change group owner
- `-R` : recursively change (for directory)
### Download logrotate
github of `logrotate` : https://github.com/logrotate/logrotate/tree/master
先下載`logrotate`這個套件。<br>
`sudo pkg install logrotate` <br>
### Log Rotate Configutation file
reference : https://superuser.com/questions/1403121/systemd-logrotate-to-specific-folder , https://adamtheautomator.com/logrotate-linux/<br>
example for config file : https://superuser.com/questions/1403121/systemd-logrotate-to-specific-folder , https://github.com/logrotate/logrotate/blob/master/examples/logrotate.conf <br><br>

Add a logrotate conﬁguration ﬁle in **`/etc/logrotate.d/fakelog`** <br>
The program will generate a log ﬁle in **`/var/log/fakelog.log`**, copy the log ﬁles to the **`/var/log/fakelog/`**. <br>

- Set the number of log ﬁles to rotate to 10. : `rotate <count>`
- Set the maximum size of each log ﬁle to 1k. : `maxsize <size>` (1k)
- Move the log ﬁles to the /var/log/fakelog/ directory. : `olddir <dir>`

`sudo ./fakeloggen.py 55 --logrotate`

希望不會被當 :D
