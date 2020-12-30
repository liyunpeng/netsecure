## fdisk分区方式
### 不做raid分区
我们先看下物理盘的情况
```
[duan@nantong6 ~]$ lsblk 
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda               8:0    0 558.4G  0 disk 
├─sda1            8:1    0     1G  0 part /boot
└─sda2            8:2    0 557.4G  0 part 
  ├─centos-root 253:0    0    50G  0 lvm  /
  ├─centos-swap 253:1    0  31.4G  0 lvm  [SWAP]
  └─centos-home 253:2    0   476G  0 lvm  /home
sdb               8:16   0 558.4G  0 disk 
[duan@nantong6 ~]$ 
```
这台机器有两块物理硬盘sda和sdb，sda又分了sda1和sda2，sda1分了1G的空间，sda2继续分了centos-root，centos-swap，centos-home，而sdb的盘没有被分区，也没有被使用

8c2b22e31ffbf1b06a9b3cc53102992e3fbf11c7
defb919053fe2485cf5662be7daa391ba984b9e0


fdisk 跟盘名称

```
[root@nantong6 duan]$ fdisk /dev/sdb
欢迎使用 fdisk (util-linux 2.23.2)。

更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。

Device does not contain a recognized partition table
使用磁盘标识符 0x046ab323 创建新的 DOS 磁盘标签。

命令(输入 m 获取帮助)：m
命令操作
   a   toggle a bootable flag
   b   edit bsd disklabel
   c   toggle the dos compatibility flag
   d   delete a partition
   g   create a new empty GPT partition table
   G   create an IRIX (SGI) partition table
   l   list known partition types
   m   print this menu
   n   add a new partition
   o   create a new empty DOS partition table
   p   print the partition table
   q   quit without saving changes
   s   create a new empty Sun disklabel
   t   change a partition's system id
   u   change display/entry units
   v   verify the partition table
   w   write table to disk and exit
   x   extra functionality (experts only)

命令(输入 m 获取帮助)：n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
分区号 (1-4，默认 1)：          直接回车
起始 扇区 (2048-1171062783，默认为 2048)：      直接回车
将使用默认值 2048
Last 扇区, +扇区 or +size{K,M,G} (2048-1171062783，默认为 1171062783)： 默认回车最大空间，或者+500G指定空间大小
将使用默认值 1171062783
分区 1 已设置为 Linux 类型，大小设为 558.4 GiB

命令(输入 m 获取帮助)：w
The partition table has been altered!

Calling ioctl() to re-read partition table.
正在同步磁盘。
[root@nantong6 duan]#
```
尽量在每次分区完成之后最好运行partprobe命令
```
[root@nantong6 duan]$ partprobe
[root@nantong6 duan]$ 
```
该命令会在系统不重启的情况下通知内核使用新的分区表，可解决在删除之前的分区而重新创建新的分区的时候遇到的目标忙，内核仍然使用旧的分区表，并且在下次重启时使用新表的情况。

分盘完成之后再次使用lsblk看下刚才的分盘情况
```
[root@nantong6 duan]# lsblk 
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda               8:0    0 558.4G  0 disk 
├─sda1            8:1    0     1G  0 part /boot
└─sda2            8:2    0 557.4G  0 part 
  ├─centos-root 253:0    0    50G  0 lvm  /
  ├─centos-swap 253:1    0  31.4G  0 lvm  [SWAP]
  └─centos-home 253:2    0   476G  0 lvm  /home
sdb               8:16   0 558.4G  0 disk 
└─sdb1            8:17   0 558.4G  0 part 
```
已经存在一个sdb1的盘，使用的是最大空间，没有挂载到任何的目录

此时sd1还并不能被直接挂在，接下来需要赋予文件系统，如果直接mount挂载会提示磁盘存在错误的超级块。

分盘完成
### raid分区
```
[root@nantong6 duan]# fdisk /dev/sdb
欢迎使用 fdisk (util-linux 2.23.2)。

更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。


命令(输入 m 获取帮助)：d
已选择分区 1
分区 1 已删除

命令(输入 m 获取帮助)：w
The partition table has been altered!

Calling ioctl() to re-read partition table.
正在同步磁盘。
[root@nantong6 duan]# partprobe
[root@nantong6 duan]# fdisk /dev/sdb
欢迎使用 fdisk (util-linux 2.23.2)。

更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。


命令(输入 m 获取帮助)：p

磁盘 /dev/sdb：599.6 GB, 599584145408 字节，1171062784 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：dos
磁盘标识符：0x046ab323

   设备 Boot      Start         End      Blocks   Id  System

命令(输入 m 获取帮助)：n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
分区号 (1-4，默认 1)：      回车
起始 扇区 (2048-1171062783，默认为 2048)：      回车
将使用默认值 2048
Last 扇区, +扇区 or +size{K,M,G} (2048-1171062783，默认为 1171062783)：     回车
将使用默认值 1171062783
分区 1 已设置为 Linux 类型，大小设为 558.4 GiB

命令(输入 m 获取帮助)：t   
Hex 代码(输入 L 列出所有代码)：L
已选择分区 1
 0  空              24  NEC DOS         81  Minix / 旧 Linu  bf  Solaris        
 1  FAT12           27  隐藏的 NTFS Win 82  Linux 交换 / So  c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux            c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 隐藏的 C:   c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux 扩展       c7  Syrinx         
 5  扩展            41  PPC PReP Boot   86  NTFS 卷集        da  非文件系统数据 
 6  FAT16           42  SFS             87  NTFS 卷集        db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux 纯文本     de  Dell 工具      
 8  AIX             4e  QNX4.x 第2部分  8e  Linux LVM        df  BootIt         
 9  AIX 可启动      4f  QNX4.x 第3部分  93  Amoeba           e1  DOS 访问       
 a  OS/2 启动管理器 50  OnTrack DM      94  Amoeba BBT       e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad 休 eb  BeOS fs        
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         ee  GPT            
 f  W95 扩展 (LBA)  54  OnTrackDM6      a6  OpenBSD         ef  EFI (FAT-12/16/
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        f0  Linux/PA-RISC  
11  隐藏的 FAT12    56  Golden Bow      a8  Darwin UFS      f1  SpeedStor      
12  Compaq 诊断     5c  Priam Edisk     a9  NetBSD          f4  SpeedStor      
14  隐藏的 FAT16 <3 61  SpeedStor       ab  Darwin 启动     f2  DOS 次要       
16  隐藏的 FAT16    63  GNU HURD or Sys af  HFS / HFS+      fb  VMware VMFS    
17  隐藏的 HPFS/NTF 64  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE 
18  AST 智能睡眠    65  Novell Netware  b8  BSDI swap       fd  Linux raid 自动
1b  隐藏的 W95 FAT3 70  DiskSecure 多启 bb  Boot Wizard 隐   fe  LANstep        
1c  隐藏的 W95 FAT3 75  PC/IX           be  Solaris 启动     ff  BBT            
1e  隐藏的 W95 FAT1 80  旧 Minix       

Hex 代码(输入 L 列出所有代码)：fd
已将分区“Linux”的类型更改为“Linux raid autodetect”

命令(输入 m 获取帮助)：w
[root@nantong6 duan]#
[root@nantong6 duan]$ partprobe
[root@nantong6 duan]$ 
```
此时raid盘已经分好可以使用fdisk -l检查一磁盘
```
[root@nantong6 duan]# fdisk -l

磁盘 /dev/sdb：599.6 GB, 599584145408 字节，1171062784 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：dos
磁盘标识符：0x046ab323

   设备 Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048  1171062783   585530368   fd  Linux raid autodetect

磁盘 /dev/sda：599.6 GB, 599584145408 字节，1171062784 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：dos
磁盘标识符：0x000094eb

   设备 Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200  1171062783   584481792   8e  Linux LVM

磁盘 /dev/mapper/centos-root：53.7 GB, 53687091200 字节，104857600 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节


磁盘 /dev/mapper/centos-swap：33.8 GB, 33755758592 字节，65929216 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节


磁盘 /dev/mapper/centos-home：511.1 GB, 511059165184 字节，998162432 个扇区
Units = 扇区 of 1 * 512 = 512 bytes
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节

[root@nantong6 duan]# 
```
可以看到sdb1已经被设置了Linux raid autodetect

分盘完成
#### 注意：当硬盘空间大于2T时，fdisk最多之会分2T的空间，而想要分超过2T的时候就要使用parted分区了
## parted分区方式
```
[root@localhost ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom
sda      8:0    0   50G  0 disk
├─sda1   8:1    0    1G  0 part /boot
├─sda2   8:2    0    2G  0 part [SWAP]
└─sda3   8:3    0   47G  0 part /
sdb      8:16   0    2T  0 disk
这时系统里有一个sdb的磁盘，容量为2TB。
[root@localhost ~]# parted /dev/sdb
(parted) mklabel gpt      # 将MBR磁盘格式化为GPT
(parted) mkpart primary 0 -1  #  0表示分区的开始  -1表示分区的结尾  意思是划分整个硬盘空间为主分区  mkpart primary 0 20TB
警告: The resulting partition is not properly
aligned for best performance.
忽略/Ignore/放弃/Cancel? I     #忽略警告
(parted) p                    #打印当前分区
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 2199GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Number  Start   End     Size    File system  Name     标志
 1      17.4kB  2199GB  2199GB               primary
(parted) quit   #退出
信息: You may need to update /etc/fstab.
[root@localhost ~]#
```
在创建raid时parted的分区是不需要向fdisk命令一样还要设置为raid类型才可以供于raid使用，

parted分区可以直接用于创建raid。

parted命令分区也不需要使用partprobe通知unix内核，因为parted命令分区是立即生效的

## 创建软raid
这里就需要使用mdadm命令了
```
yum install mdadm
apt-get install mdadm
```
#### 注意：在创建之前不要给即将要用来创建raid的盘赋予文件系统，应该是给予已经创建的raid赋予文件系统，这样是在两个盘之上创建的文件系统，两个盘就会共用一个文件系统
```
                /home/duan/test（挂载的文件夹）                            
                           |                       
                md1（软raid（mkfs.ext4）文件系统）
                           |
                           |
            —————————————————
           |                                 |
          sdb1                              sdc1         
            
```
注意：在创建raid前，应该先查看磁盘是否被识别，如果内核还为识别，创建Raid时会报错：
```
cat /proc/partitions
```
如果没有被识别需要运行
```
partprobe
```
开始创建软raid
```
mdadm -C /dev/md1 -l 1 -n 2 /dev/sdb1 /dev/sdc1
-C $创建软件RAID
-l $指定RAID级别  1表示raid1  其他同理  
-n $指定磁盘个数
-x $指定备用设备个数
-A $重组之前的设备

mdadm: array /dev/md1 started. #提示你创建成功
```
向现有的raid里添加硬盘
```
mdadm /dev/md1 -a /dev/sdb7         第一个参数跟已有的软raid设备名   第二个参数跟要加入盘的地址
```
注意：创建设备跟加入设备的时候是不能跟硬盘的uuid的，只能够使用硬盘地址

查看RAID阵列的详细信息
```
mdadm -D /dev/md#   查看指定RAID设备的详细信息
```
查看raid状态
```
[root@localhost ~]# cat /proc/mdstat
Personalities : [raid0] [raid1]
md0 : active raid0 sdb2[1] sdb1[0]
     4206592 blocks super 1.2 512k chunks
md1 : active raid1 sdb6[1] sdb5[0]
      2103447 blocks super 1.2 [2/2] [UU]
unused devices: <none>
```
移除损坏的磁盘
```
mdadm /dev/md1 -r /dev/sdb5
```
mdadm还有很多的命令这里我就不全部都写了，自行百度
#### 注意：当创建raid的时候可能会出现如下错误
```
[root@localhost ~]$ mdadm -C /dev/md1 -l 0 -n 2 /dev/sda4 /dev/sdb1
mdadm: Fail create md1 when using /sys/module/md_mod/parameters/new_array
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```
#### 但是报错之后仍然会创建md1成功，也可以挂载，但是重新开机之后就没有了这种情况极有可能是因为你的命令是直接复制过去的，并不是自己手敲的，从而导致复制过去的空格在ASCII码中和linux的空格是不一样的，解决的方法就是自己手动敲一遍就好了
## 格式化磁盘
```
[root@nantong6 duan]# mkfs.
mkfs.btrfs   mkfs.cramfs  mkfs.ext2    mkfs.ext3    mkfs.ext4    mkfs.minix   mkfs.xfs     
[root@nantong6 duan]# mkfs.ext4
Usage: mkfs.ext4 [-c|-l filename] [-b block-size] [-C cluster-size]
	[-i bytes-per-inode] [-I inode-size] [-J journal-options]
	[-G flex-group-size] [-N number-of-inodes]
	[-m reserved-blocks-percentage] [-o creator-os]
	[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]
	[-O feature[,...]] [-r fs-revision] [-E extended-option[,...]]
	[-t fs-type] [-T usage-type ] [-U UUID] [-jnqvDFKSV] device [blocks-count]
[root@nantong6 duan]# mkfs.ext4 /dev/sdb1   （mkfs.ext4 /dev/md1）
mke2fs 1.42.9 (28-Dec-2013)
文件系统标签=
OS type: Linux
块大小=4096 (log=2)
分块大小=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
36601856 inodes, 146382592 blocks
7319129 blocks (5.00%) reserved for the super user
第一个数据块=0
Maximum filesystem blocks=2294284288
4468 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	102400000

Allocating group tables: 完成                            
正在写入inode表: 完成                            
Creating journal (32768 blocks): 完成
Writing superblocks and filesystem accounting information: 完成     

[root@nantong6 duan]# 
```

1. 一旦丢失了文件系统那么磁盘中的文件仍然会存在，但是因为没有文件系统所以已经无法读取了
2. 在更换文件系统时会清除磁盘上的所有数据，包括raid存在磁盘中的超级块
3. 赋予文件系统之的时候会清除之前的文件系统和硬盘里的所有数据并且写入新的文件系统，而一般情况下只要不更换文件系统，磁盘里的数据都是存在的。
## mount挂载
### mount选项和用法
```
用法：
 mount [-lhV]
 mount -a [选项]
 mount [选项] [--source] <源> | [--target] <目录>
 mount [选项] <源> <目录>
 mount <操作> <挂载点> [<目标>]

选项：
 -a, --all               挂载 fstab 中的所有文件系统
 -c, --no-canonicalize   不对路径规范化
 -f, --fake              空运行；跳过 mount(2) 系统调用
 -F, --fork              对每个设备禁用 fork(和 -a 选项一起使用)
 -T, --fstab <路径>      /etc/fstab 的替代文件
 -h, --help              显示此帮助并退出
 -i, --internal-only     不调用 mount.<类型> 助手程序
 -l, --show-labels       列出所有带有指定标签的挂载
 -n, --no-mtab           不写 /etc/mtab
 -o, --options <列表>    挂载选项列表，以英文逗号分隔
 -O, --test-opts <列表>  限制文件系统集合(和 -a 选项一起使用)
 -r, --read-only         以只读方式挂载文件系统(同 -o ro)
 -t, --types <列表>      限制文件系统类型集合
     --source <源>       指明源(路径、标签、uuid)
     --target <目标>     指明挂载点
 -v, --verbose           打印当前进行的操作
 -V, --version           显示版本信息并退出
 -w, --rw, --read-write  以读写方式挂载文件系统(默认)

 -h, --help     显示此帮助并退出
 -V, --version  输出版本信息并退出

源：
 -L, --label <标签>      同 LABEL=<label>
 -U, --uuid <uuid>       同 UUID=<uuid>
 LABEL=<标签>            按文件系统标签指定设备
 UUID=<uuid>             按文件系统 UUID 指定设备
 PARTLABEL=<标签>        按分区标签指定设备
 PARTUUID=<uuid>         按分区 UUID 指定设备
 <设备>                  按路径指定设备
 <目录>                  绑定挂载的挂载点(参阅 --bind/rbind)
 <文件>                  用于设置回环设备的常规文件

操作：
 -B, --bind              挂载其他位置的子树(同 -o bind)
 -M, --move              将子树移动到其他位置
 -R, --rbind             挂载其他位置的子树及其包含的所有挂载
 --make-shared           将子树标记为 共享
 --make-slave            将子树标记为 从属
 --make-private          将子树标记为 私有
 --make-unbindable       将子树标记为 不可绑定
 --make-rshared          递归地将整个子树标记为 共享
 --make-rslave           递归地将整个子树标记为 从属
 --make-rprivate         递归地将整个子树标记为 私有
 --make-runbindable      递归地将整个子树标记为 不可绑定

```
### 通过设备名称挂载

```
mount /dev/sdb1 /home/duan/test     第一个参数跟设备地址    第二个参数跟挂载的地址
```
注意项：
1. 在mount的时候要挂在的目录必须是已经存在的文件夹。
2. mount的时候当前路径不能在要挂载的文件目录下。
3. 不能够有任何程序或者进程正在使用要挂载的目录。
4. 同一个目录可以被无限的mount叠加，但是真正使用的磁盘永远都是最后mount的那个盘
5. mount的时候并不会删除原来的文件夹里的任何文件,只是把文件夹的指针指向sdb1的这个磁盘上去，当umount的时候指针又会重新指回"上层"位置
6. 要mount的磁盘或者设备必须已经具备了文件系统，否者就会因为超级块错误而挂载失败
```
            /--------------------sda（本地磁盘）
test（文件夹）
            \——————————sdb1（挂载磁盘）
```
##### 这种通过直接挂载设备名称的方法虽然很简单，但是如果遇到linux启动时并没有固定盘序的话就会导致设备名称或者盘名成变调，导致开机自动挂载因为设备名称不同而挂载失败，这种情况下我们就要使用uuid去挂载了
#### 通过uuid挂载
先查看盘区的uuid

```
[root@localhost ~]# blkid
/dev/sda1: UUID="57103485-9b67-484d-b4b3-8f1fc4cbca06" TYPE="xfs" 
/dev/sda2: UUID="GQg0b4-LtO7-FSiw-CwpB-aNni-fGyr-8RVkxw" TYPE="LVM2_member" 
/dev/sr0: UUID="2018-03-22-02-29-27-00" LABEL="VMware Tools" TYPE="iso9660" 
/dev/mapper/centos-root: UUID="fed16cea-91f6-4434-a2c8-2842ab7cbf8c" TYPE="xfs" 
/dev/mapper/centos-swap: UUID="4fbd3fdc-c30d-4e46-98bd-5557f5fdc424" TYPE="swap" 
[root@localhost ~]#
```
uuid挂载
```
mount -U <UUID> </home/duan/test>
```

通过uuid挂在raid时注意uuid是raid设备名称的uuid而不是单独盘的uuid
#### mount嵌套
我们知道除了系统关键目录外，只要不影响系统的正常启动，任何目录都是可以mount的，那个这么这个时候就可以做嵌套mount
```
                 sdb1 磁盘挂载————————/home/duan/test
                                        |
                         ———————————————
                        |                              |
        test1(test内的目录空间使用sdb1空间)         test2(继续挂载)
                                                       |
                                                   sdb2磁盘挂载
```
这样我就可看出/home/duan/test使用的磁盘是sb1，而test2归属于test目录下，但是我们继续挂载test1会使用sdb1的空间，但是test2会使用sdb2的空间

假设sdb1有1G空间，sdb2有500M空间，

如果文件存到了test目录除了test2外的目录，那么就是存到了sdb1的盘中，可以使用1G的空间，

而当文件存到test2的时候此时文件就是存到了sdb2磁盘当中，那么此时我们只能使用sdb2的500M的空间

了解到这样的机制之后我们就可以无限的向下嵌套

##### 注意事项：
##### 1. 我们知道如果取消mount就会读取上一级mount的文件，而嵌套就要非常注意这一点，假设我们嵌套了五层，而当我们开机启动的时候先挂载了第五层后挂载了第一层那么整个嵌套就乱了套了

那么如何解决这样的问题呢？在后续的开机启动时我会说明该方法

### 开机自动重组raid
mdadm有自己的conf文件在开机的之后会自动运行，linux有很多的开机启动进程和服务，但是他们都有自己的启动顺序，了解linux的启动顺序是有点复杂的学习，而最简单的方式就是写到rc.local里面

添加到rc.local,通过设备名称重组
```
mdadm -A </dev/md1> </dev/sdb1> </dev/sdb2>
```
通过uuid重组
```
mdadm -A --uuid=<> </dev/md1>
```
一般情况下raid是写到磁盘当中的，所以即便是不重组开机也会有已经创建好的md1设备

#### 注意事项：
#### 1. uuid是在赋予文件系统之后生成的，而我们做好raid之后赋予文件系统，这样的话加入raid的多个盘就会有同一个uuid，所以重组的uuid必须要填加入raid盘一样的那个uuid

### 开机自动启动mount
开机自动启动有很多种方法，有fstab，raid命令也有自己的mdadm.conf文件，那么我个人认为这种方法都不是最好的方法，如果我们想要做更复杂的挂载的方式rc.local就是一个很好的解决办法

为什么rc.local是很好的解决办法呢，因为rc.local可以写各种shell脚本的命令，我们可以做各种if的判断，可以做sleep的睡眠，这样我们就可以随意的控制挂载的顺序，时间，保证挂载的百分百正确

添加到rc.local,通过设备名mount
```
mount </dev/md1> </home/duan/test>
```
使用uuidmount
```
mount -U <uuid> </home/duan/test>
```
完整的嵌套rc.local配置
```
[root@localhost ~]# cat /etc/rc.local 
#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.

touch /var/lock/subsys/local
mdadm -A mdadm -A --uuid=<> </dev/md1>      $先重组raid
sleep 1             $等待重组睡眠1秒
mount -U <uuid> </home/duan/test>   $挂载第一个盘
sleep 1
mdadm -A mdadm -A --uuid=<> </dev/md2>      $重组第二个raid
sleep 1
mount -U <uuid> </home/duan/test2>   $挂载第二个盘
```
这里我用了比较简单的睡眠来解决先后挂载的顺序，当然你也可以加入if的判断来保挂载更加的稳妥

卸载mount也很简单，运行一下命令和取消rc.local就可以了
```
umount  </home/duan/fil>    $后面跟挂载的目录就可以了
```
### 或者我们也可以在毫无关联的几个地方创建文件，然后用软连接也可以做到多层级目录使用不同的硬盘空间，但是仍然需要注意软连接的先后顺序

## 卸载raid
在卸载raid时切记不能直接stop停止raid设备然后直接删除，stop只会暂时停止raid，而remove会删掉系统中的raid信息，但不并不能删除磁盘上raid关联的超级块，如果你直接这样做就会导致系统中已经不存在raid设备了，但是磁盘中的超级块仍然记录着raid相关的信息，而这样的就会导致系统和磁盘之前记录的信息不同步，明明查不到这个raid，但是使用这个盘再次创建raid时总是提示磁盘忙，而正确的步骤应该是如下操作

第一步，stop正在运行的raid设备
```
mdadm -S </dev/md1>
```
第二步，移除raid设备上的所有磁盘的超级块
```
mdadm --misc --zero-superblock /dev/sdb1

mdadm --misc --zero-superblock /dev/sdb2
```
第三步，取消rc.local文件中的重组命令
```
vi /etc/rc.local

#mdadm -A mdadm -A --uuid=<> </dev/md1> 
```
注意：
1. 在移除超级块之后磁盘中就不具有raid关联的数据了
2. 如果不清除而对该盘重新分区会再次触发磁盘中raid相关的超级块，这样就会导致删除的raid设备莫名奇妙的分个盘又出现了
3.由于文件系统是赋予的raid设备，而移除其中的一个盘之后虽然磁盘中仍然有之前的数据，但是由于已经没有文件系统了，所以是无法直接挂载使用的，而此时磁盘中的数据也没办法读取出来了 

