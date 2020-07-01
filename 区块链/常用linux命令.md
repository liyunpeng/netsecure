
```
362: (Jun 30 16:51:10) [ bafy2bzacedfu77xs7gqoitfngk3pt6o3ezizytlzasvxkivftx3jcjotocpuw: t01000, ]
367: (Jun 30 16:53:15) [ bafy2bzacebx2bmmyo2yi6npr7j32c5hwa46f6nb46sfbezyyctwozzlcif3iq: t01000, ]
370: (Jun 30 16:54:30) [ bafy2bzacedab3xhuaedersw2wnvu4tyyqagpdzva6z4a6smzuhbzzl3eti7pw: t01000, ]
377: (Jun 30 16:57:25) [ bafy2bzacedhfs6tyrfbxmmci55cgdzbbgwyryfqz4evn7xrvvq5vfqvkxbvbk: t01000, ]
406: (Jun 30 17:09:30) [ bafy2bzaceao3fmoaodu6ggbojm4ll7rpdkohol6d3mzteej6trl42ejh4fei2: t01000, ]
411: (Jun 30 17:11:35) [ bafy2bzacecjbnhpjdo3j35rnciapkrndxifvnwyaxix5pgs2v7rfdgj66xure: t01000, ]

创世节点 8M 算力太低， 很长时间才能出块， 
```
单位：
8M=536870912
32G=


mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 10.10.13.22:/mnt/storage  /mnt/


#### 私链普通节点
```
nohup ./lotus daemon --genesis=./dev.gen --bootstrap=false --api 11234 > lotus.log 2>&1 & 

nohup ./lotus-server >lotus-server.log 2>&1 &

nohup ./lotus-storage-miner run --mode=poster --server-api=http://10.10.11.31:3456 --dist-path=/mnt --nosync > poster.log 2>&1 &

nohup ./lotus-server >lotus-server.log 2>&1 &

./lotus-storage-miner init --nosync --sector-size=536870912 --owner=t3qr64ae6azjwqewl5ivsyy7dvw73evaerkkiipavd3uqwyz7ybmpp2nxmbfr6r5jgrifmwjq2hnvsclgdpwma

./lotus-storage-miner init --nosync --sector-size=536870912 --owner=t01006

./lotus wallet new bls

./lotus wallet balance ; 

./lotus send t3地址(lotus的t3地址) 1000

nohup ./lotus-storage-miner run --mode=poster --server-api=http://10.10.11.31:3456 --dist-path=/mnt --nosync >> poster.log 2>&1 &

nohup ./lotus daemon --server-api=http://10.10.11.31:3456 --bootstrap=false --api 11234 > lotus.log 2>&1 &

FORCE_BUILDER_P1_WORKERS=28 FORCE_BUILDER_TASK_DELAY=1s FORCE_BUILDER_AUTO_PLEDGE_INTERVAL=1 TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 FORCE_BUILDER_PLEDGE_TASK_TOTAL_NUM=56 nohup ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.11.31:3456 --dist-path=/mnt --nosync --groups=1 > ./sealer.log 2>&1 &


带t0的初始化 
./lotus-storage-miner init  --nosync --owner=t01002
```


### 32G sealer   worker
HACK_P1=1   FIL_PROOFS_MAXIMIZE_CACHING=1  FIL_PROOFS_NUMS_OF_PARTITION_HACK=4  FIL_PROOFS_USE_FULL_GROTH_PARAMS=true  BELLMAN_PROOF_THREADS=8  RUST_LOG=debug  RUST_BACKTRACE=full   nohup ./force-remote-worker >> logs/force-remote-worker.log 2>&1 &
FORCE_BUILDER_P1_WORKERS=1  FORCE_BUILDER_TASK_DELAY=1h  FORCE_BUILDER_AUTO_PLEDGE_INTERVAL=10  TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1  FORCE_BUILDER_PLEDGE_TASK_TOTAL_NUM=1 nohup ./lotus-storage-miner run     --mode=remote-sealer --server-api=http://10.10.10.239:3456 --dist-path=/mnt  --nosync   --groups=1 > logs/sealer.log 2>&1 &
 

$ 



$ tail -100f lotus-server.log



#### 同步修改文件。 

```
# vi /etc/ansible/hosts
```
加入一个机会组：10多台机器。 

```
ansible ligang -m copy -a "src=/home/cmd/config.toml dest=/home/fil/ owner=fil group=fil"
```

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
ps -x


查看所有进程
ps -ef






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
