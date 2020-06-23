### force-remote-worker完成一个任务的6个阶段
 6个阶段，被划分到4个进程，真实环境下， 每个进程运行在单独的一个主机上。 
 这些主机被化作一个组。 
 每个P都有自己所在组的编号
 同一个任务的
 p1到p6 必须严格的顺序执行。 


32G 只有一个机会

测试人员开测 
#### P1
p1 做sector开始的部分，包括存储空间，时空证明，非常耗时间的。 
P1 起Nfs , P1到P6共享此nfs。

P1，P2向nfs写， 
P3, p6 从nfs读。 

P1 10个worker,  即10个P1，同时跑  
P1 用 intel要 32个小时 
P1 用 amd 只要3个小时， 

输出块的大小与时间对应
512M：    25分钟
32G：  60个小时

32G需要500G
64G需要1T
2k可以同时起500个P1

P1是所有P中最耗时的， P1会产生非常大的中间文件， p1产生的中间文件都会存放在本地的
/sealer/nfs/10.10.4.23/cache
目录下。 


可以用8组在跑32G sector， 

#### P2与P3合并
P2 会计算出 最终放在 存储服务器的块。 

P2计算出的结果文件， 存放在
/sealer/nfs/10.10.4.23/sealed目录下。 

P3产生数据， 并且copy
p2 p3 放在容器里。

#### P4与P5合并
p4 验证100多G的证明文件， 耗时1个小时多

p5 copy 耗时20分钟， p4, p5可以同时，

p5 也叫pc拷贝
pc 负责把p2产生的结果文件拷贝到存储服务器，即storage-nodes字段指定的存储服务器。 
P2生成的结果文件为512M， p5拷贝大概需要1分钟的时间。 

而P4要做一些证明的事情， 时间大概5分钟， 所以P6要等P4，完成后， 才可以删除 /sealer/nfs/10.10.4.23/cache文件， 

poster读取这个区块， 完成证明， 然后lotus 把这个区块提交到链上， 这样就封装好了一块磁盘，

#### P6
p6 clean: 本地临时 500G，结果为32G的块， 32G传出去， 就可以删除500G


### config.toml 说明
force-remote-worker读取config.toml文件。
```
[fil@yangzhou010010019017 ~]$ cat config.toml
scheduler_url = "http://10.10.19.17:3456"
local_dir = "/sealer"
copy_limit_mb_per_sec = 500
group_id= [1]
sector_size = 536870912
ip = "10.10.19.17"

[[worker]]
num = 1
supported_phase = ["PreCommitPhase1","PreCommitPhase2","CommitPhase1","CommitPhase2"]
wait_sec = 60

[[worker]]
num = 1
supported_phase = ["CopyTask","CleanTask"]
wait_sec = 60
```
配置文件的详细解释：
```
[fil@yangzhou010010019017 ~]$ cat config.toml
scheduler_url = "http://10.10.19.17:3456"
local_dir = "/sealer"

copy_limit_mb_per_sec = 500
500是限速度， 因为P1到P6 都在使用网络， 对每个P限制最大速度


group_id= [1]
sector_size = 536870912
ip = "10.10.19.17"

[[worker]]
num = 1
表示只有1个这样的worker， 一个worker是一个线程

supported_phase = ["PreCommitPhase1","PreCommitPhase2","CommitPhase1","CommitPhase2"]
表示一个work做这4个事情，

wait_sec = 60
force-remote-worker 每60秒 到sealer 分发的task表读任务， 读到任务就把is-taken字段置1， 表示这个任务已经被 orce-remote-worker领取


[[worker]]
num = 1
supported_phase = ["CopyTask","CleanTask"]
wait_sec = 60
```






### 启动force-remote-worker
```
RUST_LOG=debug BELLMAN_PROOF_THREADS=3 RUST_BACKTRACE=1 nohup ./force-remote-worker > force-remote-worker.log 2>&1 &
```



2020-06-23 17:45:39 DEBUG [hyper::client::pool] pooling idle connection for ("http", 10.10.11.39:3456)
2020-06-23 17:45:39 DEBUG [reqwest::async_impl::client] response '200 OK' for http://10.10.11.39:3456/acquire-task
2020-06-23 17:45:39 INFO [force_remote_worker::worker] {"code":0,"msg":"record not found","data":null}


#### tasks表字段含义
| is_finished | 含义| 
|----|----|
|0| 任务没完成|
|1| 任务完成|


| result_status | 含义| 
|----|----|
|0| 结果正常|
|1| 还没结束|
|2| 结果错误|

只有is_finished为1， result_status为0， 才表示该P正常完成。 

result_status为2 时， 可以手动设置为1， 这样这个P可以重做。 

#### 排查sector表大量failed
precommitfailed 消息，  就会直接走到32 任务，做清理， 中间不会经历4，8，16阶段。  



应为大量的sector卡在32， 做32的worker太少， 
修改force-remote-worker的配置文件config.toml,  p6 worker 的数量。 

worker 
512M 拷贝 30秒


##### 任务做不过去， 没有在第一时见知道。 
存储是错误的， 本来就是错误的， 是做不过去的， 但到了p3 或p5 才知道， 

### 问题排查

#### 设置核数， 避免被force-remote-worker占满
核数不能占满， 要不ssh很难连上
p2 p3 会把核占满 ， 要留下2 个核  
打开文件数目没限制， 900万个驶过没问题， 

####  /sealer 挂错了磁盘， 导致P1卡住
p1阶段， 系统搞的非常慢，p1容易在io卡住
用root用户看iostate -ix 看下写的状态
最后发现， /sealer挂上了sda系统盘
sealer 应该挂上md1磁盘。
从 df -h  应该看到 /sealer下挂载了 md1盘， 如果挂载了sda盘， 这是系统盘， 做p1时会严重影响速度。 


#### P1 做不下去的原因：
```
force-remote-worker log:
2020-06-23 17:45:39 ERROR [force_remote_worker] failed to create out dir with: "/sealer/nfs/10.10.13.22/sealed"
```
这个/sealer/nfs/10.10.13.22/sealed是取数据库表storage-nodes拼接出来的字符串。 


虽然/sealer挂载在10.10.10.21:/sealer， 但是也允许/sealer下创建其他ip的目录如
/sealer/nfs/10.10.13.22

```
[fil@yangzhou010010011039 ~]$ df -h
Filesystem                Size  Used Avail Use% Mounted on
/dev/sda4                 1.1T  112G 1001G  11% /
devtmpfs                   63G     0   63G   0% /dev
tmpfs                      63G     0   63G   0% /dev/shm
tmpfs                      63G   19M   63G   1% /run
tmpfs                      63G     0   63G   0% /sys/fs/cgroup
/dev/sda2                 3.9G  112M  3.5G   4% /boot
/dev/sda3                 128M  4.0K  128M   1% /boot/efi
10.10.10.21:/sealer        58T  113G   55T   1% /sealer
tmpfs                      13G     0   13G   0% /run/user/0
10.10.13.22:/mnt/storage   22T     0   21T   0% /mnt
```
worker会创建/sealer/nfs/10.10.13.22 但/sealer/nfs/ 是root用户， 755权限， fil用户无法创建这个目录。 

查看/sealer 下到底有没有这个目录：
```
[root@yangzhou010010011039 10.10.11.21]# ll /sealer/nfs/10.10.11.21/
总用量 8
drwxr-xr-x. 58 root root 4096 6月  23 17:55 cache
drwxrwxrwx.  2 root root 4096 6月  23 17:55 sealed
```

解决办法；  改变owner， 或改777权限
```
[root@yangzhou010010011039 sealer]# ll
总用量 24
drwxrwxrwx. 2 root root 16384 6月  21 23:59 lost+found
drwxr-xr-x. 3 root root  4096 6月  23 12:07 nfs
drwxr-xr-x. 2 root root  4096 6月  23 15:59 p3cache
[root@yangzhou010010011039 sealer]# chown -R fil:fil *
[root@yangzhou010010011039 sealer]# ll
总用量 24
drwxrwxrwx. 2 fil fil 16384 6月  21 23:59 lost+found
drwxr-xr-x. 3 fil fil  4096 6月  23 12:07 nfs
drwxr-xr-x. 2 fil fil  4096 6月  23 15:59 p3cache
```


#### p2

p2 做完后， 要发消息给 链上， 等链上处理完消息后， 才能处理P3
