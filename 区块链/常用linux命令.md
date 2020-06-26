#### 同步修改文件。 


a# cat /etc/ansible/hosts

加入一个机会组：



ansible ligang -m copy -a "src=/home/cmd/config.toml dest=/home/fil/ owner=fil group=fil"

### 版本查看
```
[root@yangzhou010010019017 ~]# cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)

md5sum 文件名
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









