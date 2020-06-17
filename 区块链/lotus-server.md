## lotus-server启动前的准备 

### nfs挂载点的准备
##### 检查所有挂在点：
```
root@yangzhou010010019017 fil]# df -h
文件系统        容量  已用  可用 已用% 挂载点
/dev/sda2       2.0T   93G  2.0T    5% /
devtmpfs         63G     0   63G    0% /dev
tmpfs            63G     0   63G    0% /dev/shm
tmpfs            63G  818M   63G    2% /run
tmpfs            63G     0   63G    0% /sys/fs/cgroup
/dev/sda1      1014M  127M  888M   13% /boot
tmpfs            63G   12K   63G    1% /var/lib/kubelet/pods/62e5b3d7-53a8-4e6f-ac34-ab536be25ea2/volumes/kubernetes.io~secret/default-token-jbj6d
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/113ad712394904013f5c02216d0d8debd465bb1cfc102511864d76ccb7c3606a/merged
shm              64M     0   64M    0% /var/lib/docker/containers/d78cd26c6125ba04748c4201e38fec61decb56699282bc3c4953d0b100acf34b/mounts/shm
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/6a223d4ff6930ff19317e4ed5dbfc3460a300657e228a307cd0118719f65c76b/merged
tmpfs            13G     0   13G    0% /run/user/0
tmpfs            63G   12K   63G    1% /var/lib/kubelet/pods/96595a99-28af-41b4-a28c-1ed683e57575/volumes/kubernetes.io~secret/default-token-62shh
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/118a85960d400fd1c4213ce17ddc821839b2f15d89fa13d38c245294423ac502/merged
shm              64M     0   64M    0% /var/lib/docker/containers/5717cf2b70e20b83dbcf68f297bfc1392011b3b58d0f57c0a973f1f86aa34599/mounts/shm
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/95cb42c1924211e42bde298635caa68862c9589404abe07022e2ab002535e7cf/merged
```

#####  挂载nfs文件系统
```
[root@yangzhou010010019017 ~]# mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 10.10.4.23:/mnt/storage  /mnt/nfs/10.10.4.23
```

若要开机挂载， 就在rc.local中加：
```
root@yangzhou010010019017 ~]# cat /etc/rc.local
```

##### 查看新的挂载点
```
[root@yangzhou010010019017 mnt]# df -h
文件系统                 容量  已用  可用 已用% 挂载点
/dev/sda2                2.0T   93G  2.0T    5% /
devtmpfs                  63G     0   63G    0% /dev
tmpfs                     63G     0   63G    0% /dev/shm
{
tmpfs                     63G  818M   63G    2% /run
tmpfs                     63G     0   63G    0% /sys/fs/cgroup
/dev/sda1               1014M  127M  888M   13% /boot
tmpfs                     63G   12K   63G    1% /var/lib/kubelet/pods/62e5b3d7-53a8-4e6f-ac34-ab536be25ea2/volumes/kubernetes.io~secret/default-token-jbj6d
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/113ad712394904013f5c02216d0d8debd465bb1cfc102511864d76ccb7c3606a/merged
shm                       64M     0   64M    0% /var/lib/docker/containers/d78cd26c6125ba04748c4201e38fec61decb56699282bc3c4953d0b100acf34b/mounts/shm
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/6a223d4ff6930ff19317e4ed5dbfc3460a300657e228a307cd0118719f65c76b/merged
tmpfs                     13G     0   13G    0% /run/user/0
tmpfs                     63G   12K   63G    1% /var/lib/kubelet/pods/96595a99-28af-41b4-a28c-1ed683e57575/volumes/kubernetes.io~secret/default-token-62shh
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/118a85960d400fd1c4213ce17ddc821839b2f15d89fa13d38c245294423ac502/merged
shm                       64M     0   64M    0% /var/lib/docker/containers/5717cf2b70e20b83dbcf68f297bfc1392011b3b58d0f57c0a973f1f86aa34599/mounts/shm
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/95cb42c1924211e42bde298635caa68862c9589404abe07022e2ab002535e7cf/merged
10.10.4.23:/mnt/storage  160T  273G  152T    1% /mnt/nfs/10.10.4.23
```

出现了10.10.4.23:/mnt/storage  160T  273G  152T    1% /mnt/nfs/10.10.4.23
说明10.10.4.23存储服务器的/mnt/storage已经成功挂载到当前主机的/mnt/nfs目录下

到挂在点下的目录，看有无内容
```
[root@yangzhou010010019017 mnt]# cd nfs/10.10.4.23/
[root@yangzhou010010019017 10.10.4.23]# ll
总用量 40
drwxrwxr-x 537 fil fil 20480 6月  13 14:00 cache
drwxrwxr-x   2 fil fil 20480 6月  13 14:00 sealed
```

#####  递归改变nfs目录下所有文件的属主
```
[root@yangzhou010010019017 mnt]# chown -R fil:fil nfs
[root@yangzhou010010019017 mnt]# chmod -R 777 nfs/
```

#### sealed 存放最后计算出的区块：
矿工号为t02481， lotus全部过程搭建好后， 可以在sealed看到所有矿工计算出的区块， 区块的编号由矿工号和任务号拼接层

```
[fil@yangzhou010010019017 sealed]$ pwd
/mnt/nfs/10.10.4.23/sealed
fil@yangzhou010010019017 sealed]$ ll | grep 2481
-rw-rw-r-- 1 fil fil 536870912 Jun 13 18:17 s-t02481-3000
-rw-rw-r-- 1 fil fil 536870912 Jun 13 19:43 s-t02481-3002
-rw-rw-r-- 1 fil fil 536870912 Jun 13 19:43 s-t02481-3003
-rw-rw-r-- 1 fil fil 536870912 Jun 13 23:42 s-t02481-3004
-rw-rw-r-- 1 fil fil 536870912 Jun 14 00:01 s-t02481-3005
-rw-rw-r-- 1 fil fil 536870912 Jun 14 13:40 s-t02481-3006
-rw-rw-r-- 1 fil fil 536870912 Jun 14 13:40 s-t02481-3007
-rw-rw-r-- 1 fil fil 536870912 Jun 14 15:11 s-t02481-3008
```
 
### 数据库准备
#### 测试数据库联通：
```
[root@yangzhou010010019017 fil]# telnet 10.10.19.15 3306
Trying 10.10.19.15...
Connected to 10.10.19.15.
Escape character is '^]'.
J
5.7.30
```

#### 复制数据库
跳板机登陆到10.10.19.15
```
[root@yangzhou010010001015 ~]# ssh -p 62534 10.10.19.15
Last login: Wed Jun 17 08:39:23 2020
[root@yangzhou010010019015 ~]# ifconfig
bond0: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
        inet 10.10.19.15  netmask 255.255.0.0  broadcast 10.10.255.255
```

创建数据库lotus17a
```
[root@yangzhou010010019015 ~]# mysql -uroot -pIpfs@123ky
mysql> create database `lotus17a` ；
mysql> exit 
```

数据库lotus的所有表复制到lotus17a：
```
[root@yangzhou010010019015 ~]#  mysqldump lotus -u root -pIpfs@123ky --add-drop-table | mysql lotus17a -u root -pIpfs@123ky
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
[root@yangzhou010010019015 ~]# exit
```


#### 数据库表中添加记录行：
打开navicat,在fconfigs, groups表中添加数据 

#### config.json 中修改数据库

[root@yangzhou010010019017 fil]# vi Config.json
将"dbConnString":后的内容改为
"root:Ipfs@123ky@tcp(10.10.19.15:3306)/lotus17?loc=Local&parseTime=true",
  
```
[fil@yangzhou010010019017 ~]$ cat config.json
{
  "port": "3456",
  "dbConfig": {
    "dbConnString": "root:Ipfs@123ky@tcp(10.10.19.15:3306)/lotus17?loc=Local&parseTime=true",
    "dbType": "mysql",
    "dbDebugMode": true
  },
  "sealerSleepDurationSeconds":60,
  "lockLifeCircleMinutes": 40,
  "sectorStoreZoneMap": {
    "2048": 3078,
    "8388608": 12582912,
    "34359738368": 51539607552,
    "536870912": 805306368
  }
}
```
config.json由lotus-server读取,  lotus-server把数据保存到数据库中， 配置文件制定了数据库的地址


###  期望最后应该跑起来的进程
```
[fil@yangzhou010010019017 ~]$ ps -ef | grep lotus
fil       1113     1  0 Jun13 ?        00:23:28 ./lotus-storage-miner run --mode=remote-wdposter --server-api=http://10.10.19.17:3456 --dist-path=/mnt --nosync
fil       6765     1 20 Jun13 ?        08:22:15 ./lotus daemon --server-api=http://10.10.19.17:3456 --msg-api=http://10.10.19.17:5678/rpc/v0
root      8513     1  0 Jun13 ?        00:23:46 ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.19.17:3456 --dist-path=/mnt --nosync --groups=1
fil      18297     1  0 Jun13 ?        00:05:44 ./lotus-message daemon --network=interop
fil      39825     1  0 Jun13 ?        00:00:35 ./lotus-server
[fil@yangzhou010010019017 ~]$ ps -ef | grep forc
fil      22667     1 22 Jun13 ?        09:20:20 ./force-remote-worker
```

### 启动lotus-server
```
$ nohup ./lotus-server >lotus-server.log 2>&1 &
```
