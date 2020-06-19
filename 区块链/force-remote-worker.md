### force-remote-worker完成一个任务的6个阶段
 6个阶段，被划分到4个进程，真实环境下， 每个进程运行在单独的一个主机上。 
 这些主机被化作一个组。 
 每个P都有自己所在组的编号
 同一个任务的
 p1到p6 必须严格的顺序执行。 


32G 只有一个机会

测试人员开测








-----
核数不能沾满， 要不恨难ssh很难连上

p2 p3 会把核占满 ， 要留下2 个核  

p1 主要 io卡住

用root用户看。iostate, sda系统盘

打开文件数目没限制， 900万个没问题， 

---
sealer 应该挂在 /mnt/md1, 
从 df -h  应该看到 /sealer下挂载了 md1盘， 如果挂载了sda盘， 这是系统盘， 做p1时会严重影响速度。 


iostate -ix 看下写的状态

---



---
这8组在跑32G sector， 






 
 
 
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

####  限速
copy_limit_mb_per_sec = 500
500是限速度， 因为P1到P6 都在使用网络， 对每个P限制最大速度

#### force-remote-worker查询任务的频率
wait_sec = 60
force-remote-worker 每60秒 到sealer 分发的task表读任务，  读到任务就把is-taken字段 指1， 表示这个任务已经被 orce-remote-worker领取

#### P1 到 P6 的编排
supported_phase = ["PreCommitPhase1","PreCommitPhase2","CommitPhase1","CommitPhase2"]
表示一个work做这4个事情， 

### 启动force-remote-worker
RUST_LOG=debug BELLMAN_PROOF_THREADS=3 RUST_BACKTRACE=1 nohup ./force-remote-worker > force-remote-worker.log 2>&1 &
