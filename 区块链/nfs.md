# nfs的安装、搭建和使用
**NFS是Network File System的简写，即网络文件系统。它常用来在局域网内共享目录和文件，还可以做为NAS（Network Attached Storage：网络附属存储）。**

**一个NFS的典型部署是：NFS服务器把部分本地文件系统做为NFS共享；NFS客户端挂载这些服务器文件系统，然后就可以像本地文件系统一样操作远程的文件系统。**

下面记录了NFS服务器和客户端的安装步骤，并进行NFS共享，服务器和客户端都使用在CentOS 7系统。


```
#### 配置NFS服务端，拿扬州新节点举例说明

#### 服务端：10.10.30.46

#### 客户端：10.10.30.45

yum install nfs-utils

当然可以以离线安装，安装环境包
所需的环境安装包我已经放在了Nextcloud的/运维（小组内）/mount目录下

安装命令

rpm -i 要安装的nfs包
```
注意：虽然 * 号表示所有的安装包，但是在实际执行的时候并不会安装全部的包，所以在执行之后要手动查看所有的安装包是否全部安装

## 服务端配置


准备一个要共享的目录
```
mkdir /mnt
mkdir /mnt/storage
chmod 777 /mnt/storage
```
打开/etc/exports文件，默认改文件是空的，在文件中添加如下一段代码
```
/mnt/storage *(rw,sync,insecure,no_root_squash)

nfs参数详解
/mnt/storage    要共享的目录
*               表示所有网段的节点均可访问，注意，只限内网
rw              可读，可写
sync            所有数据在请求时写入共享
async           NFS在写入数据前可以相应请求
secure          NFS通过1024以下的安全TCP/IP端口发送
insecure        NFS通过1024以上的端口发送
wdelay          如果多个用户要写入NFS目录，则归组写入（默认）
no_wdelay       如果多个用户要写入NFS目录，则立即写入，当使用async时，无需此设置。
Hide            在NFS共享目录中不共享其子目录
no_hide         共享NFS目录的子目录
subtree_check   如果共享/usr/bin之类的子目录时，强制NFS检查父目录的权限（默认）
no_subtree_check    和上面相对，不检查父目录权限
all_squash      共享文件的UID和GID映射匿名用户anonymous，适合公用目录。
no_all_squash   保留共享文件的UID和GID（默认）
root_squash    root用户的所有请求映射成如anonymous用户一样的权限（默认）
no_root_squas   root用户具有根目录的完全管理访问权限
anonuid=xxx     指定NFS服务器/etc/passwd文件中匿名用户的UID

例如可以编辑/etc/exports为：
/tmp　　　　　*(rw,no_root_squash)
/home/public　192.168.0.*(rw)　　 *(ro)
/home/test　　192.168.0.100(rw)
/home/linux　 *.the9.com(rw,all_squash,anonuid=40,anongid=40)
```
然后更新配置文件，使之生效
```
exportfs -rv
```
启动相关服务：
```
systemctl enable rpcbind

systemctl start rpcbind

systemctl enable nfs-server

systemctl start nfs-server
```
配置防火墙打开NFS服务端口
```
firewall-cmd --zone=public --add-service=nfs --permanent

firewall-cmd --zone=public --add-service=rpc-bind --permanent

firewall-cmd --zone=public --add-service=mountd --permanent

firewall-cmd --reload
```
**注意：虽然我们通过防火墙配置了nfs的服务，并且在客户端直接写数据可能是没有问题的，但是一旦运行go-filecoin可能就会出现问题，最显而易见的现象就是无法查看挂载目录，df命令卡死，go-filecoin卡住起不来**

**而出现这种现象的原因就是go-filecoin并没有使用nfs固定的端口去访问，导致防火墙拒绝了nfs的请求，而此时nfs客户端无法与服务端通信，而nfs客户端默认采用hard-mount选项，而不是soft-mount。**

**他们的区别是**

**soft-mount: 当客户端加载NFS不成功时，重试retrans设定的次数.如果retrans次都不成功，则放弃此操作，返回错误信息 "Connect time out"**

**hard-mount: 当客户端加载NFS不成功时,一直重试，直到NFS服务器有响应。**

这里我并没有更改这个选项，因为这样可以保证数据传输出现异常之后nfs仍然能够自己处理异常再次重新连接。

因为扬州的存储服务器都是存在内网之中的，并没有暴露在公网上，所以我选择最简单，最暴力的方法：关闭防火墙所有服务

```
查看防火墙状态： systemctl status firewalld.service

绿的running表示防火墙开启

执行关闭命令： systemctl stop firewalld.service

再次执行查看防火墙命令：systemctl status firewalld.service

执行开机禁用防火墙自启命令  ： systemctl disable firewalld.service

============================================================
启动：systemctl start firewalld.service

防火墙随系统开启启动  ： systemctl enable firewalld.service
```
查看共享的目录：
```
exportfs
```
到此服务端配置完成

## 客户端配置

此时需要安装mount目录下的所有包
```
rpm -i *.rpm

rpm -i mergerfs-2.25.1-1.el7.x86_64.rpm
```
注意：虽然 * 号表示所有的安装包，但是在实际执行的时候并不会安装全部的包，所以在执行之后要手动查看所有的安装包是否全部安装

客户端命令步骤如下
```
rpm -i *.rpm            安装包

mkdir -p /mnt/node46    创建挂载文件夹

umount /mnt/node46      先umount掉谨防有之前mount的记录

mount -t nfs -o vers=3 10.10.30.46:/mnt/storage /mnt/node46     从46的/mnt/storage挂载到45的/mnt/node46

具体参数上面已经有解释，更多请自行百度
```
### mergerfs

我能在网上找到的mergerfs教程极少，在github中找到了该项目的说明和使用
```
https://github.com/trapexit/mergerfs

https://manpages.debian.org/experimental/mergerfs/mergerfs.1.en.html
```
我们使用的命令
```
umount /home/fil/.filecoin_sectors

mergerfs -o threads=1,category.create=rand,dropcacheonclose=true,hard_remove,noforget,allow_other,use_ino /mnt/node57:/mnt/node46 /home/fil/.filecoin_sectors

threads         线程数，这里注意线程数过多会导致服务器吞吐量下降，当传输时一个线程就会占用90%以上，没必要配两个

dropcacheonclose=true       内存优化参数

allow_other                 允许所有用户操作
其他参数请参照官网
```
开启启动的话加入到rc.local即可
