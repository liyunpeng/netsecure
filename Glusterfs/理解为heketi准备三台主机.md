heketi是管理glussterfs文件系统的，
在没有heketi， 只有glusterfs情况下， pod 如果需要一块硬盘分区， 就需要手动用glusterfs创建一个逻辑卷分区并在分区上建立glusterfs文件系统，
硬盘只有在有了文件系统后， 才能在硬盘上读写数据。
glusterfs创建和分区和在分区上建立文件系统， 需要繁琐的手动命令， 
包括gluster peer probe, gluster create等， 每个命令都需要很多参数设定，如peer probe需要设定存放glusterfs文件系统的主机ip，create需要设定复制卷， 还是条带卷， 还要指明分区的挂再目录， 
然后再创建一个该分区的pv, 然后再创建pvc。
以上这么多的动作都需要手动， 
在有了heketi之后，只需要创建一个pvc,  heketi会自动以server api的方式调用glusterfs命令， 并自动根据pvc的卷大小自动向glusterfs命令设定参数

准备好三台有/dev/sdb硬盘的主机， 每台主机都需要做的准备有：
###  1. 创建一个/dev/sdb1硬盘分区， 命令为：
$ sudo fdisk /dev/sdb 
一路默认选项，建立/dev/sdb1裸硬盘分区

### 2. 设置好主机名
hostname  ip地址的最后部分-node
修改 /etc/hostname , 改为ip地址的最后部分-node， 使其重启后仍然生效
比如在192.168.0.217的机器上：
```
$ sudo hostname 217-node 
$ sudo vi /etc/hostname, 
文件内容改为217-node 
```
### 3. 设置好局域网内的域名解析， 
每行包括解析的域名和ip
所有这些都要放在每台主机的/etc/hosts
```
$ sudo vi /etc/hosts
192.168.0.217     217-node
192.168.0.218     218-node
192.168.0.219     219-node
```
### 4.  三台机器都用kubectl join加入到k8s集群
