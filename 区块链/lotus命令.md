```
[fil@yangzhou010010019017 ~]$ ./lotus wallet balance
49.999900675992993622
```

```
./lotus wallet export t3qji2z3u2e243cboxl32irkokkkvbj4moktuapni64ig6pwdpcun5mqr5xcsj346avwd6ek6opue2gwqjj6fa
```

```
$ ./lotus-message wallet import --nonce=52 7b2254797065223a22626c73222c22507269766174654b6579223a22473230664e33767566356d5133534b614c466c496862625a46416e5555744d382f334e38417a634d5756733d227d

```
获取t3地址
```
[fil@yangzhou010010019017 ~]$ [fil@yangzhou010010019017 ~]$ ./lotus wallet list
 t3tdha666hzopozcjnkarijatngjhmshoca3g4qdcvdp7pregoxk6mkhkflwup2yck7flmlga6mt7iicgmf6ra
```

[fil@yangzhou010010019017 ~]$ ./lotus state get-actor
2020-06-14T11:27:42.345+0800	WARN	main	must pass address of actor to get

[root@yangzhou010010019017 ~]# cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)

接下来需要等待节点同步数据，可以通过以下方式跟踪同步状态：
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
其中 height: 是当前同步的区块高度。如果同步完成了这个值会编程 0， 
也可以去 https://lotus-metrics.kittyhawk.wtf/chain 查看当前开发网络最新区块高度和其他网络指标。


　　
可以新打开一个终端窗口，检查是否已连接到网络：
./lotus net peers | wc -l

　　

[fil@yangzhou010010019017 ~]$ ./lotus sync wait
Worker 0: Target: [bafy2bzacebxaqrchyvcuumqogczibhlzr6oe3b2l56wyjckdj6qvq5c65467a bafy2bzacebofds5jygmv5ztmckwxom2lhkmiyhrmljrd5xzpz33pwezg4pwpo 


[fil@yangzhou010010019017 ~]$ ./lotus chain list
15792: (Jun 13 16:08:00) [ bafy2bzacecjjabsxfkpvpxj5prfmsqjf363a62b2swfmt5765qggkdrwxx7co: t01845,bafy2bzacea34hx2pi4pnax7t77bejwvvdfa6utk56legofi6d2w5wbwiq2ges: 


[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner info
Mode: poster
Miner: t02481
Sector Size: 512 MiB
Byte Power:   512 MiB / 135 TiB (0.0003%) .  算力 。 
Actual Power: 512 Mi / 101 Ti (0.0004%)     算力太小，  
 没有出块
	Committed: 512 MiB
	Proving: 512 MiB
Expected block win rate: 0.0691/day (every 347h13m20s)

Miner Balance: 0.00009932400698959
	PreCommit:   0
	Locked:      0.000096344821570454
	Available:   0.000002979185419136
Worker Balance: 49.999900675992993622
Market (Escrow):  0
Market (Locked):  0


### 查看块的编号
[fil@yangzhou010010019017 sealed]$ ls | grep 2481
s-t02481-3000

3000是任务id

把跳版机当前目录的下所有文件同步到17主机上的/home/fil目录下
[root@yangzhou010010001015 20200612]# scp -rpP 62534 * 10.10.19.17:/home/fil


查看全网算力
$ lotus-storage-miner state power

查看指定矿工的算力
$ lotus-storage-miner state power <miner>

查看指定矿工的扇区密封状态
$ lotus-storage-miner state sectors <miner>
------------
1.加入测试网络
（1.）删除原有点数据
rm -rf ~/.lotus ~/.lotusstorage
（2.）设置网关
IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"
（3.）启动守护进程
lotus daemon
（4.）查看网络连接数
lotus net peers | wc -l
（5.）同步数据
lotus sync wait
（6.）创建钱包
lotus wallet new bls
示例：lotus wallet new bls
t3wkzqsqsyo7fcyp7mll6tvhqp7wkynu7d2znksz4cq4qxhxnyl5q6wlwp2krp6rnk4l2lepsacsmnisvkcdna
(7)获取测试币
https://lotus-faucet.kittyhawk.wtf/funds.html
（8.）查看钱包余额
lotus wallet balance t3wkzqsqsyo7fcyp7mll6tvhqp7wkynu7d2znksz4cq4qxhxnyl5q6wlwp2krp6rnk4l2lepsacsmnisvkcdna
（9.）发送filecoin给其他地址
lotus send
（10.）查看最新点出块高度，以及出块时间
https://stats.testnet.filecoin.io/d/z6FtI92Zz/chain?orgId=1&refresh=45s&from=now-30m&to=now&kiosk

2.filecoin测试网络页面
https://stats.testnet.filecoin.io/d/z6FtI92Zz/chain/?orgId=1&refresh=45s&from=now-30m&to=now&kiosk

3.挖矿
（1.）设置环境变量
IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"
（2.）安装 启动矿工
make lotus-seal-worker //lotus-seal-worker 编译lotus-seal-worker
lotus-seal-worker run //LOTUS_STORAGE_PATH 进行鉴权

（3.）查看矿工是否已经连接到存储矿
lotus-storage-miner info // lotus-storage-miner 存储矿工点逻辑，有独立的进程，通过节点提交信息和时空工作量证明来存储节点信息
（4.）配置文件
~/.lotusstorage/config.toml

otus 命令
1，查看区块高度
2，扇区查看
3，查看创建的块
1，查看区块高度
watch -d -n 1 'lotus chain getblock $(lotus chain head | head -n 1) | jq .Height'
1


watch -d -n 1 'date -d @$(lotus chain getblock $(lotus chain head | head -n 1) | jq .Timestamp)'
1


2，扇区查看
本节点扇区列表
# lotus-storage-miner sectors list
1: PreCommitFailed	sSet: NO	pSet: NO	tktH: 17998	seedH: 0	deals: [509748]
2: SealCommitFailed	sSet: NO	pSet: NO	tktH: 18572	seedH: 18637	deals: [524978]	
1
2
3
扇区状态查看
# lotus-storage-miner sectors status 1
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
1
2
3
4
5
6
7
8
9
10
11
12
13
节点ID
# lotus net id
1
3，查看创建的块
在最近1000个区块中t01475创建的块
# lotus-storage-miner chain list --count 1000 | grep t01475 | wc -l
992


