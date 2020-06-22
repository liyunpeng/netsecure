
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


查看当前开发网络最新区块高度和其他网络指标： 
https://lotus-metrics.kittyhawk.wtf/chain 

获取测试币：
https://lotus-faucet.kittyhawk.wtf/funds.html

查看最新点出块高度，以及出块时间
https://stats.testnet.filecoin.io/d/z6FtI92Zz/chain?orgId=1&refresh=45s&from=now-30m&to=now&kiosk

filecoin测试网络页面
https://stats.testnet.filecoin.io/d/z6FtI92Zz/chain/?orgId=1&refresh=45s&from=now-30m&to=now&kiosk

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


### 链接到比较快的节点

如果小于3个， 说明没连上， 

一旦连上， net peers 会一下子看到很多节点， 因为是p2p的， 连到了比较快的群里的一个节点， 马上就能连到群里的其他节点。 

lotus net peers 可以看到多个链接节点， lotus会起3个worker，每个worker就是一个并行的线程， 每个worker都会去连peers里的一个节点， lotus sync status 看到的就是这三个work

如果链同步慢， 可以手动去连一个快的节点：

```
lotus net connect 其他节点的地址
```

再用lotus net peers会看到新链接的节点地址


###  查看链

#### 1.   查看有没有同步好
```
[fil@yangzhou010010019017 ~]$ ./lotus sync wait
Worker 0: Target: [bafy2bzaced7jcgcxvsl7h2o34ozoitfqkjnk4zo5w72ytjyrz2kx4cva6mumo]	State: complete	Height: 26527
Done!
```
只有lotus sync wait显示Done!才表示链同步成功

如果lotus sync wait还在阻塞， 说明还在进行同步。 
#### 2. 查看链高度

```
lotus sync wait
Target: [bafy2bzacedm7m4gfctogyii7fzhn4a3n66x5v5kvee33z26pve63qup7bhuts]	State: complete	Height: 2594
Done
```

看最后一次同步的时间：

#### 3. 查看本地链与全局链的高度差
```
$ ./lotus sync status 
[fil@yangzhou010010019017 ~]$ ./lotus sync status
sync status:
worker 0:
	Base:	[bafy2bzaceavjkgq3547gtxrke5kcdtd7oz76wl5rjlqsrlez5vilseorqxmti bafy2bzaceaaehkye63fhnsx4ojf6pojstpdount7hsfrsrxb7cpajcob75muc bafy2bzacedsr23oouqb466nvkpwd5hpgljb2mbmcczpjc7tvlsj6f46nl3h22 bafy2bzacebkoosenjo43hnx4jokrm7xe4njyklhsh5o5ddcd723ghzmavptdg bafy2bzacearcvx7syok2rrvmtxb4oy5wzfc62wkfib4k5jtzb6umgq7ahnslm]
	Target:	[bafy2bzacebygtdppvtgczvlsnb5zd5adgjxhab2gaog6orsfjhfrnwq5cx2as bafy2bzacebfg6gqchyyumxw2gexzxwn5tocf6xy5z3hjq3mr77gs46vmqhdtk bafy2bzacealxpx2y2fhrtxljlnnhhcljj2su4u3l4pwumbmrbamdyyhw5kw74 bafy2bzaceaxraaxrh3oi2lmzxwnmsq6b4rreg42worgsql2uphz7vjrbsngq4 bafy2bzaceaqi7nn5p2i6ufu5njwhcdjfrqkuh2v2oiifphfn4fg5of5wvlwfo] (25889)
	Height diff:	3304
	Stage: complete
	Height: 25889
	Elapsed: 14m47.505612586s
worker 1:
	Base:	[bafy2bzacebygtdppvtgczvlsnb5zd5adgjxhab2gaog6orsfjhfrnwq5cx2as bafy2bzacebfg6gqchyyumxw2gexzxwn5tocf6xy5z3hjq3mr77gs46vmqhdtk bafy2bzacealxpx2y2fhrtxljlnnhhcljj2su4u3l4pwumbmrbamdyyhw5kw74 bafy2bzaceaxraaxrh3oi2lmzxwnmsq6b4rreg42worgsql2uphz7vjrbsngq4 bafy2bzaceaqi7nn5p2i6ufu5njwhcdjfrqkuh2v2oiifphfn4fg5of5wvlwfo]
	Target:	[bafy2bzaceauq5h4k5pssudua2qjdzq6tzai7x5537l6y5o2vf32wzbzi3as4e bafy2bzacecuriyn32xum5ft7243vthbxo6yyadjlrbkhwq2ohcsryneigzaxc bafy2bzaceccdbekmzvxnr2tpho56m3cwv6gd3elpeg42nutgvmcmem32v6r4o bafy2bzaceb2jcyvvhvouugjfje5ec6n6zk5gxr2figzgqvkswjl5giisgaaq2 bafy2bzacecd3pcgzbonngeclwfh5iid53gg5fyhrjj7vvldjgyy2malhdqrbw] (25915)
	Height diff:	26
	Stage: complete
	Height: 25915
	Elapsed: 9.489860608s
worker 2:
	Base:	[bafy2bzacebygtdppvtgczvlsnb5zd5adgjxhab2gaog6orsfjhfrnwq5cx2as bafy2bzacebfg6gqchyyumxw2gexzxwn5tocf6xy5z3hjq3mr77gs46vmqhdtk bafy2bzacealxpx2y2fhrtxljlnnhhcljj2su4u3l4pwumbmrbamdyyhw5kw74 bafy2bzaceaxraaxrh3oi2lmzxwnmsq6b4rreg42worgsql2uphz7vjrbsngq4 bafy2bzaceaqi7nn5p2i6ufu5njwhcdjfrqkuh2v2oiifphfn4fg5of5wvlwfo]
	Target:	[bafy2bzacebvr6vbhfsst6ewwcuwjiskfcl77gj4bebxqb4iryvmodloufkf4c bafy2bzacea37nzzyot2ng7g7jt4nmjx7qbwhwhr7epfdlhaejfstkxa5kj3sy] (25892)
	Height diff:	3
	Stage: complete
	Height: 25892
	Elapsed: 2.075633127s
```
height diff: 表示本地链和公链差了3个高度， 
state:complete 还不能表示同步成功, 要用lotus sync wait看：
lotus chain list 可以看到同步的高度。

###  ./lotus/datastore为全局链的所有数据
同步好后， 目前可以看到.lotus/datstore为3G多
```
[fil@yangzhou010010019017 ~]$ du -sch .lotus/*
4.0K	.lotus/api
4.0K	.lotus/config.toml
3.3G	.lotus/datastore
8.0K	.lotus/keystore
0	.lotus/repo.lock
4.0K	.lotus/token
3.3G	total
```

#### 查看连接节点数量
```
./lotus net peers | wc -l
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




#### 查看钱包余额
lotus wallet balance t3wkzqsqsyo7fcyp7mll6tvhqp7wkynu7d2znksz4cq4qxhxnyl5q6wlwp2krp6rnk4l2lepsacsmnisvkcdna

#### 发送filecoin给其他地址
lotus send




### 扇区查看
#### 本节点扇区列表

```
$ lotus-storage-miner sectors list
1: PreCommitFailed	sSet: NO	pSet: NO	tktH: 17998	seedH: 0	deals: [509748]
2: SealCommitFailed	sSet: NO	pSet: NO	tktH: 18572	seedH: 18637	deals: [524978]
```

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
跳班机root用户目录下的lotus是interfil，是官方的

我们的lotus 在 lotus官方的基础上开发的， 需要合进我们开发的代码， 私链上可以用， 不需要官方申请

内部开发的是用：
https://stats.testnet.filecoin.io/d/3j4oi32ore0rfjos/chain-internal