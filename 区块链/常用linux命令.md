#### 同步修改文件。 

```
# vi /etc/ansible/hosts
```
加入一个机会组：10多台机器。 

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






### ansible

```
[root@jumpserver01-yz cmd]# ansible ligang  -m shell -a "cd /home/fil;  ./restartprocess f^C
[root@jumpserver01-yz cmd]# vi /etc/ansible/hosts
[root@jumpserver01-yz cmd]# ansible ligang  -m shell -a "cd /home/fil;  ./restartprocess f"
[DEPRECATION WARNING]: The TRANSFORM_INVALID_GROUP_CHARS settings is set to allow bad characters in group names by default, this will change, but still be user configurable on
deprecation. This feature will be removed in version 2.10. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

10.10.10.21 | CHANGED | rc=0 >>
运行前
fil      172498      1 42 6月24 ?       20:51:57 ./force-remote-worker
返回值=1
重启 worker
运行后
root     141829      1  0 16:48 pts/0    00:00:00 ./force-remote-worker

10.10.11.34 | CHANGED | rc=0 >>
运行前
fil      23557     1 99 6月24 ?       2-18:28:31 ./force-remote-worker
返回值=1
重启 worker
运行后
root     31413     1  0 16:48 pts/0    00:00:00 ./force-remote-worker

10.10.11.38 | CHANGED | rc=0 >>
运行前
fil      29233     1 44 6月24 ?       22:27:24 ./force-remote-worker
返回值=1
重启 worker
运行后
root     29741     1  0 16:48 pts/0    00:00:00 ./force-remote-worker

10.10.11.37 | CHANGED | rc=0 >>
运行前
fil      25506     1 29 6月24 ?       15:03:53 ./force-remote-worker
返回值=1
重启 worker
运行后
root     23401     1  0 16:48 pts/0    00:00:00 ./force-remote-worker

10.10.11.40 | CHANGED | rc=0 >>
运行前
fil      19108     1 42 6月24 ?       21:30:15 ./force-remote-worker
返回值=1
重启 worker
运行后
root      8817     1  0 16:48 pts/0    00:00:00 ./force-remote-worker

10.10.11.39 | CHANGED | rc=0 >>
运行前
fil      37383     1 36 6月24 ?       18:12:14 ./force-remote-worker
返回值=1
重启 worker
运行后
root      1737     1  0 16:48 pts/0    00:00:00 ./force-remote-worker

10.10.11.36 | CHANGED | rc=0 >>
运行前
fil      23722     1 99 6月24 ?       2-17:04:58 ./force-remote-worker
返回值=1
重启 worker
运行后
root     29113     1  0 16:48 pts/0    00:00:00 ./force-remote-worker

10.10.11.35 | CHANGED | rc=0 >>
运行前
fil      24015     1 99 6月24 ?       2-22:05:50 ./force-remote-worker
返回值=1
重启 worker
运行后
root     29772     1  0 16:48 pts/0    00:00:00 ./force-remote-worker
```


例子：
```
 ansible-playbook -i hosts-storage-6-22 test.yml -f 30

ansible-playbook -i hosts-storage-6-22 03storage_node_init.yml --step

ansible nodes-all -m shell -a "ps -ef|grep force |grep -v grep "
 
ansible ligang -m copy -a "src=/home/cmd/config.toml dest=/home/fil/ owner=fil group=fil"
 
 
ansible yz-0-19  -m shell -a "mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 10.10.7.31:/sealer   /sealer"
```
