
### 浏览器查看链上信息
我们自己开发的浏览器：
https://interopnet.filscan.io/#/

右上角是 挖矿排名， 
左边是 算力排名
右下是 消息列表 
点from 字段， 可以看到该t3发出的所有消息， 

method 是消息类型， 

PreCommitSector 是p2 发出的消息
ProveCommitSector 是p4 发出的消息
transfer 是转账消息


### lotus 命令选项参数
```
[fil@yangzhou010010019017 ~]$ ./lotus -h
NAME:
   lotus - Filecoin decentralized storage network client

USAGE:
   lotus [global options] command [command options] [arguments...]

VERSION:
   0.4.0+git.4b923c9ce

COMMANDS:
   daemon   Start a lotus daemon process
   help, h  Shows a list of commands or help for one command
   basic:
     send     Send funds between accounts
     sendmsg  Send message to an actor with specific subcmd
     wallet   Manage wallet
     client   Make deals, store data, retrieve data
     msig     Interact with a multisig wallet
     paych    Manage payment channels
     version  Print version
   developer:
     auth          Manage RPC permissions
     mpool         Manage message pool
     state         Interact with and query filecoin chain state
     chain         Interact with filecoin blockchain
     log           Manage logging
     wait-api      Wait for lotus api to come online
     fetch-params  Fetch proving parameters
   network:
     net   Manage P2P Network
     sync  Inspect or interact with the chain syncer

GLOBAL OPTIONS:
   --help, -h     show help (default: false)
   --version, -v  print the version (default: false)
```


### 查看同步
跟踪同步状态：
```
[fil@yangzhou010010019017 ~]$ ./lotus sync status
sync status:
worker 0:
	Base:	[bafy2bzaceb5gezkmdliwxyxnvq6hupewumq5fy2rbmcudyb3b25p4xgf24bq2 bafy2bzaceb2ts3hcaoft4mckf27ktajjxaoik7ofbvqbmlgdbvvzp53khbklk]
	Target:	[bafy2bzacecmzfnqvc6uvb4sv5v3f2eybozky65wcz5gyaiuqr52u2gf3urqam bafy2bzacecklhf2iede4ppdkftg4sqput5jthzi7sb2zitfkelsr4jpnznvgo bafy2bzacea3btrzzqjmyf3h2kg52kqrjxbmulx55uwe3kvea7refwa7alzyyg bafy2bzaceb57oeak4znllm6jxbuptoyt7tlcftzp2h7xtcyg24hvi7qslk64g] (16877)
	Height diff:	192
	Stage: complete
	Height: 16877
	Elapsed: 49.098481578s
worker 1:
	Base:	[bafy2bzacedgukfgfl277qvdnda6kan7igpevvrdftf3n45nqbv4fyxjtcymxu bafy2bzacedr6icqbqqz4uwsiisumkqmv2ywkjq572lrqfdbzsnnleplsvz63g bafy2bzaceaeuevx645hb2l3jvrsv2bte5hwanzc2w3zljsqpmp4zxjacitdc4]
	Target:	[bafy2bzacea2o3qsyw7gsydcgcr5naoj2t3adlon77276twlcylqy3z2ihsvp4 bafy2bzacebnawsqw2guvhz4ui56y6e2qtmavp4vkqdtjw6maemrb5i34k4hyw bafy2bzaceaj222ckcrxt3bv34vigdyzaevosyi4r4wvbs55uv4rwcspxqy5ns bafy2bzaceamejd2to64szsmgislfgxscq4hunfglyvbqcij2qpnnx7obg75xm] (17117)
	Height diff:	192
	Stage: complete
	Height: 17117
	Elapsed: 51.82307429s
worker 2:
	Base:	[bafy2bzacecmzfnqvc6uvb4sv5v3f2eybozky65wcz5gyaiuqr52u2gf3urqam bafy2bzacecklhf2iede4ppdkftg4sqput5jthzi7sb2zitfkelsr4jpnznvgo bafy2bzacea3btrzzqjmyf3h2kg52kqrjxbmulx55uwe3kvea7refwa7alzyyg bafy2bzaceb57oeak4znllm6jxbuptoyt7tlcftzp2h7xtcyg24hvi7qslk64g]
	Target:	[bafy2bzacedgukfgfl277qvdnda6kan7igpevvrdftf3n45nqbv4fyxjtcymxu bafy2bzacedr6icqbqqz4uwsiisumkqmv2ywkjq572lrqfdbzsnnleplsvz63g bafy2bzaceaeuevx645hb2l3jvrsv2bte5hwanzc2w3zljsqpmp4zxjacitdc4] (16925)
	Height diff:	48
	Stage: complete
	Height: 16925
	Elapsed: 11.793627683s
```
其中 height: 是当前同步的区块高度。

如果同步完成了这个值会编程 0， 
也可以去 https://lotus-metrics.kittyhawk.wtf/chain 查看当前开发网络最新区块高度和其他网络指标。


#### 查看连接节点数量
```
./lotus net peers | wc -l
```
#### 实时看到同步区块高度

区块高度同步完成, 显示done退出
```
lotus sync wait
Target: [bafy2bzacedm7m4gfctogyii7fzhn4a3n66x5v5kvee33z26pve63qup7bhuts]	State: complete	Height: 2594
Done
```

看最后一次同步的时间：
```
[fil@yangzhou010010019017 ~]$ ./lotus chain list
15792: (Jun 13 16:08:00) [ bafy2bzacecjjabsxfkpvpxj5prfmsqjf363a62b2swfmt5765qggkdrwxx7co: t01845,bafy2bzacea34hx2pi4pnax7t77bejwvvdfa6utk56legofi6d2w5wbwiq2ges: 
```

存放链的数据的大小
```
[fil@yangzhou010010019017 ~]$ du -sch .lotus/datastore/
2.6G	.lotus/datastore/
2.6G	total
```

#### 查看证明文件大小
```
[fil@yangzhou010010019017 ~]$ du -sch  /var/tmp/filecoin-proof-parameters/
178G	/var/tmp/filecoin-proof-parameters/
178G	total
```

### 查看块的编号
```
[fil@yangzhou010010019017 sealed]$ ls | grep 2481
s-t02481-3000
```
3000是任务id

查看全网算力
$ lotus-storage-miner state power

查看指定矿工的算力
$ lotus-storage-miner state power <miner>

查看指定矿工的扇区密封状态
$ lotus-storage-miner state sectors <miner>

设置网关
IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"


#### 获取测试币
https://lotus-faucet.kittyhawk.wtf/funds.html

#### 查看钱包余额
lotus wallet balance t3wkzqsqsyo7fcyp7mll6tvhqp7wkynu7d2znksz4cq4qxhxnyl5q6wlwp2krp6rnk4l2lepsacsmnisvkcdna

#### 发送filecoin给其他地址
lotus send


#### 查看最新点出块高度，以及出块时间
https://stats.testnet.filecoin.io/d/z6FtI92Zz/chain?orgId=1&refresh=45s&from=now-30m&to=now&kiosk

2.filecoin测试网络页面
https://stats.testnet.filecoin.io/d/z6FtI92Zz/chain/?orgId=1&refresh=45s&from=now-30m&to=now&kiosk


### 2，扇区查看
#### 本节点扇区列表
$ lotus-storage-miner sectors list
1: PreCommitFailed	sSet: NO	pSet: NO	tktH: 17998	seedH: 0	deals: [509748]
2: SealCommitFailed	sSet: NO	pSet: NO	tktH: 18572	seedH: 18637	deals: [524978]	

#### 扇区状态查看
```
$ lotus-storage-miner sectors status 1
SectorID:	1
Status:	PreCommitFailed
CommD:		fcbeeaccf316d229fea7b14af2c44f86f324dd4b5f87910d89396b86aa4f0d0f
CommR:		e657feab945d01929d32d7ad47fc3ec469ed44a86c31c7766d9761ee609f6738
Ticket:		17e5aec42bca1b0f2b8905067eb5837262367a0618b66f5bb37f9b535e4caeb6
TicketH:		17998
Seed:		0000000000000000000000000000000000000000000000000000000000000000
SeedH:		0
Proof:
Deals:		[509748]
Retries:		0
Last Error:		entering state PreCommitFailed: found message with equal nonce as the one we are looking for (F:bafy2bzaceadspgtd5izfs5wivroa244reux6yyxxdtcmzpb5fvbxvbqydzbum n 2, TS: bafy2bzacebi474pboqkrmnpkbaf4iyovqsoqpxuszigkggkfkjulm5wjrspdc n2)
```

#### 查看创建的块
在最近1000个区块中t01475创建的块
```
$ lotus-storage-miner chain list --count 1000 | grep t01475 | wc -l
992
```


#### lotus的开发
跳班机root用户目录下的lotus是interfil， 是官方的

我们的lotus 在 lotus官方的基础上开发的， 需要合进我们开发的代码， 私链上可以用， 不需要官方申请

内部开发的是用：
https://stats.testnet.filecoin.io/d/3j4oi32ore0rfjos/chain-internal