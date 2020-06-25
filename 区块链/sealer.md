
### 启动sealer前的准备
 miner 初始化， 在 《搭建公有链》 有叙述
 
### 启动sealer
sealer 一般在另一台主机启动， 这里为学习方便， 用本机的root用户启动 sealer
要注意端口号的重复
启动sealer
```
FORCE_BUILDER_P1_WORKERS=1 FORCE_BUILDER_TASK_DELAY=25m TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 FORCE_BUILDER_TASK_TOTAL_NUM=2 nohup ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.19.17:3456 --dist-path=/mnt --nosync --groups=1 > sealer.log 2>&1 &
```
#### 启动searler的参数
FORCE_BUILDER_P1_WORKERS 不必和config.toml中的有PreCommitPhase1的worker数目相同
```
[[worker]]
num = 1
supported_phase = ["PreCommitPhase1","PreCommitPhase2","CommitPhase1","CommitPhase2"]
wait_sec = 60
```

config.toml设置为1， FORCE_BUILDER_P1_WORKERS可以设置为10
FORCE_BUILDER_TASK_TOTAL_NUM  一般是 FORCE_BUILDER_P1_WORKERS  的2倍加1 


### 本地链发出的消息的查看
消息都是sealer发出的， $cat sealer.log 看很多消息
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

查看特定的消息
```
./lotus state search-msg bafy2bzacedpyu3yt3g7ppoqmbc24ripo7s23oygga5tse2x4z7ugryvtmdmgkB
```

### sealer 做的事情
#### 1. 发任务
把任务写到数据库，实现发任务

#### 2. sealer每隔一段时间读取数据库， 将p2，p4完成的消息发给lotus
P2，P4通过中间数据库发送消息
P1到P6与外界的联系只有中间数据库方式。 没有其他方式， 消息队列，微服务，api服务等都没有。  

P2 结束会将tasks表质1， sealer每60秒读一次表， 最终将消息发到链上， 
P4 结束后也会同样机制发消息到链上， P4消息正常处理后，所对应的sector会进入proving状态,  表示sector被链承认， 

p4正常工作完，表示 P4所在的sector已经上到链上， sectors表也会把相应的sector的状态改为proving. 

只有sector进入proving状态，矿工的硬盘大小和cpu速度等信息都会提交到了链上， 这时矿工的算力才会被计算出来， miner info 才能看到有算力输出， 

P2 P4 发消息机制
P2 做完之后， 会修改tasks表的一个字段， sealer每分钟扫描tasks表， 这个字段被sealer扫到，sealer 就会把消息发给 lotus， 如果lotus启动配置msg-api配置， lotus就会自己把消息发到链上，如果有配置msg-api, lotus就会把消息发给lotus-message, 由lotus-message把消息发到链上。 

P2 发的消息， 在网页上看到的方法列的名字是 PreCommitSector
P4 发的消息， 在网页上看到的方法列的名字是 ProveCommitSector

消息发到链上， 指消息会广播链上的所有节点， 有时， 链产生了分叉， 需要lotus-message 手动发送消息， 只有消息发到链上， sector才能上链。

### sealer正常的判读
tasks表正常

sealer.log没有error

### 问题排查
####  1. 如果media-info表没填， sealer.log会包 Call xx sector错误。
cat searler.log,到最后 看sector 出错， 
看表， 
media-infos 表 缺少了一行， 确保media-infos的sector,  从config.toml配置文件sector-size字段的值拷贝过去， 

重启sealer


####  2. sealer没有起来的排查

sealer 没起来， sealer.log抱：
failed to load miner actor state: address not found 
已经做作lotus init初始化， 但这个只是在fil用户下做的， 
root用户下也要做， .lotusstorage目录
只要有poseter或dealer的地方， 就需要有storage miner的初始化， 

lotus init 先在fil 用户下初始化好 ， 
lotus init 也要在 root 下初始化， 
root用户在lotus 初始化前需要做的准备：
把fil用户下的.lotus/api token两个文件要同步到root用户下的相同文件
然后删除 root用户下的 .lotusstorage目录， 
然后在root用户做 lotus 初始化，
 
 
 

