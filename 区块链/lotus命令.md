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


