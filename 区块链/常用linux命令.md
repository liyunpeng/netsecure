### 版本查看

[root@yangzhou010010019017 ~]# cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)

md5sum. 
### 不同主机之间文件拷贝
[root@yangzhou010010001015 20200612]# scp -rpP 62534 * 10.10.19.17:/home/fil

### 配置查看
[fil@yangzhou010010001015 ~]$ cat /proc/cpuinfo| grep "cpu cores"| uniq
cpu cores	: 10
[fil@yangzhou010010001015 ~]$ grep MemTotal /proc/meminfo
MemTotal:       32818656 kB

[fil@yangzhou010010019017 ~]$ cat /proc/cpuinfo| grep "cpu cores"| uniq
cpu cores	: 12
[fil@yangzhou010010019017 ~]$  grep MemTotal /proc/meminfo
MemTotal:       131912620 kB

### 进程查看
只查看本用户启动的进程
[fil@yangzhou010010019017 ~]$ ps -x


查看所有进程
[fil@yangzhou010010019017 ~]$ ps -ef


### MySQL完整复制表到另一个新表
创建新表
CREATE TABLE newuser LIKE user; 

导入数据
INSERT INTO newauser SELECT * FROM user;