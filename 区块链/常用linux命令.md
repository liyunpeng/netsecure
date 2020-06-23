

### 版本查看
```
[root@yangzhou010010019017 ~]# cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)

md5sum 文件名
``` 
### 不同主机之间文件拷贝
```
[root@yangzhou010010001015 20200612]# scp -rpP 62534 * 10.10.19.17:/home/fil
```

mac 开发本的文件 拷贝到 跳板机
```
$ scp -rpP 62534 -i ~/.ssh/id_rsa lotus root@222.189.237.2:/home/ligang/
```

### 配置查看
```
[fil@yangzhou010010001015 ~]$ cat /proc/cpuinfo| grep "cpu cores"| uniq
cpu cores	: 10
[fil@yangzhou010010001015 ~]$ grep MemTotal /proc/meminfo
MemTotal:       32818656 kB

[fil@yangzhou010010019017 ~]$ cat /proc/cpuinfo| grep "cpu cores"| uniq
cpu cores	: 12
[fil@yangzhou010010019017 ~]$  grep MemTotal /proc/meminfo
MemTotal:       131912620 kB
```

### 文件查看
```
du -sch *
```

### 进程查看
只查看本用户启动的进程
[fil@yangzhou010010019017 ~]$ ps -x


查看所有进程
[fil@yangzhou010010019017 ~]$ ps -ef


### MySQL完整复制表到另一个新表
```
创建新表
CREATE TABLE newuser LIKE user; 

导入数据
INSERT INTO newauser SELECT * FROM user;
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








