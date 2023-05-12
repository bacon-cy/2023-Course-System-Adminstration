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
>   Finished!

為了知道新增的硬碟叫什麼名字，先`ls /dev`然後把印出來的內容截圖起來。接著用`shutdown`把VM關機以後再用VMware shutdown機器。
打開VM設定，新增三顆大小為1GB的虛擬硬碟。
> VMware的步驟如下 : 
>   1) 在Hardware底下按Add按鈕
>   2) 新增一個硬碟
>   3) 選擇硬碟的種類 (VMWare預設建議用SCSI)
>   4) 選擇 `Create a new virtual disk`，如果是已經新增好了也可以選擇`Using an existing disk`
>   5) 將大小設定為1GB
>   完成!

### 然後發現沒辦法 zpool create D: 
希望不會被當 :D
