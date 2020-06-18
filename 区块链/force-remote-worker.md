### force-remote-worker完成一个任务的6个阶段
 6个阶段，被划分到4个进程，真实环境下， 每个进程运行在单独的一个主机上。 
 这些主机被化作一个组。 
 每个P都有自己所在组的编号
 同一个任务的
 p1到p6 必须严格的顺序执行。 

### 消息机制
P2 结束会发消息到链上， 
P4 结束后也会消息， P4消息正常处理后， sector会进入proving,  节点被链承认，只有这样， miner info 才能看到有算力输出， p4正常工作完，表示 P4所在的sector已经上到链上， sectors表也会把相应的sector的状态改为proving. 


P2 P4 发消息机制
P2 做完之后， 会修改tasks表的一个字段， sealer每分钟扫描tasks表， 这个字段被sealer扫到，sealer 就会把消息发给 lotus， 如果lotus启动配置msg-api配置， lotus就会自己把消息发到链上， 如果有配置msg-api, lotus就会把消息 发给lotus-message, 由lotus-message把消息发到链上。 

P2 发的消息， 在网页上看到的 precommit

P4 发的消息， 在网页上看到的是， prove....

消息发到链上， 指消息会广播链上的所有节点， 有时， 链产生了分叉， 需要lotus-message 手动发送消息， 只有消息发到链上， sector才能上链。 



### 消息打包

$ cat sealer.log 看很多消息
```
2020-06-16T13:55:24.844+0800	INFO	remote-sealer	PreCommitPhase1 for sector 7798794642 elapsed 30.014234298s
2020-06-16T13:55:24.844+0800	INFO	sectors	trying to acquired prepared deal for pledged sector 7798794642
2020-06-16T13:55:24.844+0800	WARN	sectors	unable to acquire prepared deal: %!w(*xerrors.errorString=&{no available deal {[7143598 16703064 5584986]}})
2020-06-16T13:55:24.844+0800	INFO	sectors	Sector 7798794642 update state: PreCommit2 ...
2020-06-16T13:55:24.847+0800	INFO	serverapi	SectorEnd:{"code":0,"msg":"","data":null}

2020-06-16T13:55:24.847+0800	INFO	remote-sealer	PreCommitPhase2 for sector 7798794642 start ...
2020-06-16T13:55:24.848+0800	WARN	remote-sealer	unable to poll task status for {PreCommitPhase2 {1008 7798794642}}: record not found
2020-06-16T13:55:24.854+0800	INFO	serverapi	new-task res: {"code":0,"msg":"","data":null}
```


```
./lotus state search-msg bafy2bzacedpyu3yt3g7ppoqmbc24ripo7s23oygga5tse2x4z7ugryvtmdmgkB
```


上链是为了 得到算力， 上链与出块的数据没有关系， 只是为了

最重目地是为了出块 ， 

全网最全的算力才有机会获取出块权， 

出块会把所有的消息打包， 消息打包的费用归入这个算力的矿工 

每个矿工 都有一个消息池，  在出块的时候， 会把所有矿工的消息池打包， 

如果消息在消息打包的时候进来， 可能不会进入包。 



### 消息的nonce只
nonce 是下一个消息的id, 

每个消息都会带上nonce, 链要求， 到每个矿工到链上的消息必须严格有序， 如果nonce没有按序， 链就不会承认这个消息。 造成消息发不出去。 




查看具体的算力：


### sector表fail的排查
 查sealer.log, 依次查找fail的sector编号。 

查lotus.log, 过滤错误：
```
[fil@yangzhou010010019017 ~]$ cat lotus.log | grep -ia error | grep -v occurred

2020-06-18T17:48:46.260+0800	WARN	jsonrpc2	error in RPC call to 'Filecoin.MpoolPushMessage': mpool push: not enough funds: 100019999999534257 < 184607875762874096:
```

 显示资金不足
 
 链上每条消息的处理， 都需要付费， 一个块上链需要P2 p4两个消息处理 。 
 
 
 
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
