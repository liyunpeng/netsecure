
### poster主要做的事情

poster 做windowpost 和出块两件事情， 

#### 一， 对sector做window post证明， 
P4消息发到链上后， 
从浏览器看到provencommit的success，  表示这个消息所对应的sector的信息已经上链了, 简称sector上链
同时sectors表能看到proving, 

sector上链之后， poster就可以对这个sector做windowpost证明， 不是立即做， 要等一会. 而且以后要每隔固定时间， 都要做windowpost证明 

从poster.log看到：
```
2020-06-19T10:32:56.116+0800	INFO	storageminer	generating windowPost	{"sectors": 4}
2020-06-19T10:32:56.117+0800	INFO	storageminer	submitting window PoSt	{"elapsed": 0.000443517}
2020-06-19T10:36:08.098+0800	INFO	storageminer	running windowPost	{"chain-random": "5ayz5dvY4RxqH1gBB1LkirBOoXwWmcGgfd2Nf4C6Zic=", "deadline": {"CurrentEpoch":43710,"PeriodStart":40830,"Index":30,"Open":43710,"Close":43806,"Challenge":43690,"FaultCutoff":43690}, "height": "43710", "skipped": 0}
202
```
poster对sector做完证明后， 会把证明完成的消息发到链上， 这个消息的method叫SubmitWindowedPoSt, 网页用中文显示，可以看到提交时空证明。 P4提交的证明叫做数据提交证明。 

poster做的这个证明叫postwindow证明， 也叫时空证明。  
时空证明可以简单的这样理解：比如用户32G数据保存在我这里，我要每过一段时间，证明数据在我这里， 没有丢失， 这个叫时空证明， 

从 proving deadlines 可以看到 window post的证明情况
```
[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner proving deadlines
deadline  sectors  partitions  proven
0         0        0           0
1         36       18          0
2         36       18          0
3         36       18          0
4         36       18          0
5         36       18          0
```
现在是每隔40分钟证明一次，一次证明一个partition, 一个partion包括两个sector. proven是证明的partiton的个数 

poster完成一次证明， 会向链上发一条SubmitWindowedPoSt 消息， 
可以在浏览器消息里method列看到这个消息。 
#### 二， 出块
出块，是本节点获得出块权， 将链上消息打包。 

一个高度对应一个tipset,  一个tipst可以由多个块组成， 目前规定一个tipset最多有5个块，  从浏览器可以看到每个高度的tipset由几个块组成

./lotus chain list 每一行就是一个高度：
包括高度值， 高度上每个快的的hash值，和出该块的矿工号
```
[fil@yangzhou010010019017 ~]$ ./lotus chain list
43750: (Jun 19 10:37:13) [ bafy2bzacednb2uww5i57guren4muxmmujir7i3ixrxzgf6njtr3f7libadivm: t01003, ]
```

矿工在出块前要对此块与前一个块之间的所有消息进行打包，  

每个节点向链上发消息， 都要为消息处理付一定的费用

此块与前一个块的消息的所有缴纳的费用全部都转入此次消息打包的矿工账号 


### poster生成的文件

#### 1. 文件
证明文件   /mnt/nfs/10.10.4.23/caches

##### 2. 数据库表


### log 信息


### 判断poster是否正常
#### 1. 查看算力
```
[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner info
Mode: poster
Miner: t01003
Sector Size: 2 KiB
Byte Power:   588 KiB / 600 KiB (98.0000%)
Actual Power: 588 Ki / 690 Ki (85.2173%)
	Committed: 2.69 MiB
	Proving: 588 KiB (2.12 MiB Faulty, 78.66%)
Expected block win rate: 43200.0000/day (every 2s)

Miner Balance: 52812.59398882125816547
	PreCommit:   0
	Locked:      52211.965497554934544959
	Available:   600.628491266323620511
Worker Balance: 945.389642209971088202
Market (Escrow):  0
Market (Locked):  0
```
上面的信息详细解释：
```
[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner info
Mode: poster
表示是一个poster

Miner: t01003

Sector Size: 2 KiB
sector大小为2Kb， 目前真实网络的sector是32G

Byte Power:   588 KiB / 600 KiB (98.0000%)。
原值算力, 600KiB 是全网的总算力， 即全网所有sector的总大小。 
算力是sector大小的倍数， 算力也可以是百分比， 即占全网的算力的百分数
 
Actual Power: 588 Ki / 690 Ki (85.2173%)。
有效算力，有写入，会被奖励， 会被乘10.  这里没有写入，和原值算力相等

	Committed: 2.69 MiB  
   已经上链的sector总大小有2.6M， 上链是指sector的消息，sector的位置，大小等所有     信息都在这个消息里

	Proving: 588 KiB (2.12 MiB Faulty, 78.66%)
   虽然有很多sector已经上链，但其中很多sector没有被poster做时空证明，即poster没有证明这些sector还存在。
   这里完成证明的sector只有588K， 没有被证明的sector有2.12M， 即78%没有被证明， sector上链了， 但没有证明， 算力会被惩罚，所以算力到了588K， 就没有增长。
	
Expected block win rate: 43200.0000/day (every 2s)

Miner Balance: 52812.59398882125816547
	PreCommit:   0
	Locked:      52211.965497554934544959
	Available:   600.628491266323620511
Worker Balance: 945.389642209971088202
Market (Escrow):  0
Market (Locked):  0
```
所以commited 很多， 而proving很少时， 就说明 poster不正常了。 
    

#### 2. 查看proven
查看proven， 即查看poster的证明情况
```
[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner proving deadlines
deadline  sectors  partitions  proven
0         0        0           0
1         36       18          0
2         36       18          0
3         36       18          0
4         36       18          0
5         36       18          0
6         36       18          0
7         36       18          0
8         36       18          0
9         36       18          0
10        36       18          0
```

poster每隔40分钟， 做一次任务， 36个sector需要证明， 但是proven为0， 表示没有被证明， 


#### 3. 查看poster.log
证明的任务由poster完成， 查poster.log: 
```
[fil@yangzhou010010019017 ~]$ cat poster.log | grep -ai error
2020-06-19T10:23:20.163+0800	ERROR	storageminer	when running wdpost for partition 466, got err could not read from path="/mnt/218/cache/s-t01003-2218/p_aux"
    No such file or directory (os error 2)
```
poster会把证明文件存放到一个路径下 ，这个路径拼接而成. 

poster会调用lotus-server获取， lotus-server读数据库获取， 返回给poster

lotus-server读取的表为storage-nodes表：
```
1	10.10.4.23	1	10.10.4.23	nfs
```
最后拼接出的路径为:
```
/mnt/nfs/10.10.4.23/caches
```

据此判断， poster启动时没有带上server-api,  制定参数的地方
```
[fil@yangzhou010010019017 ~]$ ps -ef | grep lotus
fil       7050     1  1 Jun18 ?        00:18:18 ./lotus-storage-miner run --mode=poster --dist-path=/mnt --nosync
fil       9383 44996  0 11:39 pts/2    00:00:00 grep --color=auto lotus
root     28231     1  1 Jun18 ?        00:19:54 ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.19.17:3456 --dist-path=/mnt --nosync --groups=1
fil      33248     1  0 Jun18 ?        00:06:58 ./lotus-server
fil      45161     1 13 Jun18 ?        02:40:14 ./lotus daemon --server-api=http://10.10.19.17:3456 --bootstrap=false --api 11234
[fil@yangzhou0100
```

poster server-api参数没有指定， 
重启poseter, 带上server-API， 

数据库都是被server-api读取， 然后poster再从server-api读取， 拼接成存储证明文件的地址为
1	10.10.4.23	1	10.10.4.23	nf
/mnt/nfs/10.10.4.23/caches/xxx




---
