#### 链高度跟不上时间的原因
出块完全又poster负责， 所以链的高度完全又poster决定。   poster一方面不断完成对上链的sector做证明的事情， 一方面要去竞争出块。 
有时poster 有点问题了， 没能在规定的25秒内完成出块， 高度就跟不上时间了。 y
有时poster挂掉了，  造成的后果是：
1. 已上链的sector， 没能证明， 算力会被惩罚
2. 出不了块，如果只有这一个矿工， 这个矿工算力又很高， 但poster挂了，就不能出块。  创世节点算力很低， 也出不了块 ， 造成这个链的高度停滞。 


####  只要高度一致， 就可以收到链上反馈的消息
sync wait 不需要到done,   只要高度一致， 就收到了链上消息的反馈， 不会挡住sector的状态往前走。   如果因为没有消息反馈， sector会被挡在commitwait,   不是committing，

在私网测试， 会遇到这种sync wait没到done, sector状态不会因为消息而挡住状态往前走。 
尤其只有一个矿工情况下， 会遇到sync wait 不能到done的情况， sector也能proving。  就看这个矿工的高度， 和创世节点的高度是否一致即可。 

在公网测试一般不会遇到链高度跟不上时间的。 因为矿工们会争抢着出块。 保证在25秒内出块。 

#### 排查链长时间高度不变
./lotus chain list  
高度时间滞后了两天， 

重启创世节点的矿工， 即重启下面进程：
nohup ./lotus-storage-miner run --nosync >miner.log 2>&1 &
 
tail -f miner.log , 可以看到创世节点矿工在不断的出块。 但是时间很慢， 如果高度差了两天， 建议还是重新做创世节点

```
[il@yangzhou010010010240 ~]$ tail -f miner.log 
2020-07-03T16:02:03.762+0800    INFO    miner   miner/miner.go:268      attempting to mine a blocktipset[bafy2bzacecnujidmmk3lv22oqjkwyzwwpbyawb3vto7wujfumhs2trvq22ouu]
2020-07-03T16:02:03.934+0800    INFO    miner   miner/miner.go:302      Time delta between now and our mining base: 148398s (nulls: 0)
2020-07-03T16:02:03.955+0800    INFO    storageminer    storage/miner.go:201    Computing WinningPoSt ;[{SealProof:1 SectorNumber:3 SealedCID:bafk4ehzaxtyk53mmtseunwydsvqkfu5ktz2bmagndz3jelvmdahaqv7xguca}]; [131 172 123 169 205 2 221 250 48 250 130 0 151 104 55 17 221 223 92 114 11 5 193 141 104 115 28 193 37 66 20 145]
2020-07-03T16:02:13.087+0800    INFO    storageminer    storage/miner.go:208    GenerateWinningPoSt took 9.132165707s
2020-07-03T16:02:13.099+0800    INFO    miner   miner/miner.go:362      mined new block {"cid": "bafy2bzacebxthiv6jzt3fwqrlujitz63zefmdorhtjlypahm4gwccilhrcteq", "height": "867", "took": 9.337780656}
2020-07-03T16:02:13.100+0800    WARN    miner   miner/miner.go:180      mined block in the past {"block-time": "2020-07-01T22:49:10.000+0800", "time": "2020-07-03T16:02:13.100+0800", "duration": 148383.100041268}
2020-07-03T16:02:13.144+0800    WARN    miner   miner/miner.go:162      base height is 867 null rounds is 0
2020-07-03T16:02:13.144+0800    INFO    miner   miner/miner.go:268      attempting to mine a blocktipset[bafy2bzacebxthiv6jzt3fwqrlujitz63zefmdorhtjlypahm4gwccilhrcteq]
2020-07-03T16:02:13.798+0800    INFO    miner   miner/miner.go:302      Time delta between now and our mining base: 148383s (nulls: 0)
2020-07-03T16:02:13.820+0800    INFO    storageminer    storage/miner.go:201    Computing WinningPoSt ;[{SealProof:1 SectorNumber:4 SealedCID:bafk4ehzazi6fbbs6xzeh4ck5ntg2dbrq7sxahq3bo27glrdqqd2zjlnb6buq}]; [132 199 187 163 211 41 202 42 158 103 140 31 131 40 123 120 68 79 219 161 75 141 170 168 100 4 235 247 128 183 182 133]
```
这样的出块速度， 要很长时间才能让链高度跟上时间。 

lotus 有error， 高度跟不上时间是个容易发生的事。 

#### 排查长时间处于commiting

首先查看消息是否正常
1. 先看消息有没有积压
```
$ ./lotus mpool pending 
```
为空， 说明没有积压

2. 看发送的消息nonce值是否正常

先看当前的nonce， 即下一个所要发送消息的nonse值
```
$ ./lotus wallet list
t3u3gvryswjtzzxbzb4g7tipjtiektbskjte2sgpvn4zwgsffbyo6fin7udyf7cq4kveirwxwzx2jwvdlbmfha
$ ./lotus state get-actor t3u3gvryswjtzzxbzb4g7tipjtiektbskjte2sgpvn4zwgsffbyo6fin7udyf7cq4kveirwxwzx2jwvdlbmfha
Address:        t3u3gvryswjtzzxbzb4g7tipjtiektbskjte2sgpvn4zwgsffbyo6fin7udyf7cq4kveirwxwzx2jwvdlbmfha
Balance:        499.999999999999499608
Nonce:          57
Code:           bafkqadlgnfwc6mjpmfrwg33vnz2a
Head:           bafy2bzaceadx4ik2pavnurrqn3tqink7cmb5fseb7bdx42qsqggg6mc2mzang
```
转帐，促发一个消息生成
```
$ ./lotus send t01002 0.001
bafy2bzacecnwi63o26nglosuldg3hoqwyl4oon36e2m6xe7qwq67ikd3od6pq
```

消息不会立即上到链上，而是先广播出去， 广播即是放到消息池里面， 所以在这个消息池看下新生成的消息的nonse值对不对
```
$ ./lotus mpool pending 
{
  "Message": {
    "Version": 0,
    "To": "t01002",
    "From": "t3u3gvryswjtzzxbzb4g7tipjtiektbskjte2sgpvn4zwgsffbyo6fin7udyf7cq4kveirwxwzx2jwvdlbmfha",
    "Nonce": 57,
    "Value": "1000000000000000",
    "GasPrice": "0",
    "GasLimit": 10000,
    "Method": 0,
    "Params": ""
  },
  "Signature": {
    "Type": 2,
    "Data": "pA/0FcNrr4MASmlw5eOCU7UFjt+0cKxBMxYAnsvCPyZpObUfpQoKI++K9Iu1DnhfCn463e7vI5wJ6XU1Zr3ya1rdwdZOthSAyVHtHmcaEPmvQyKrWwxDYy74F1qQ2kSR"
  }
}
```
nonce值是对的， 说明消息没有问题。 

最后定位到， 16 任务执行了， 但8任务没有执行， 根本原因是P4没有起来， P4是专门做任务8的

#### sector状态含义
sector 的 几个状态：

| 状态 | 含义| 512M 持续时间
|---|---|---|
new |
PreCommit1 | 正在做P1  | 
PreCommit2 | 正在做P2  |
PreCommitting | 
PreCommitWait | p2 消息已经发出， 但没收到链上对该消息的回复
Committing | P3 P4还在忙别的事情 |
CommitWait | 本地验证ok, p4消息已经发出， 但还没有得到链上回复
WaitSeed | p2消息已经发出，而且也得到了链上的回复，等待P3来领任务
ComputeProofFailed |  sealer验证错误
Proving |  p4消息已经发出,链上已回复，上链完成
FinalizeSector |  

committing 包括了p3, p4. 还有p4做完后， sealer还在验证的事情。 

P4
commitwait 说明 P4已经做完， 

#### sector表 状态示列
sql查询得到
```
select  state, COUNT(*) from sectors GROUP BY state：

Committing	1566
CommitWait	1
ComputeProofFailed	3
FinalizeSector	1
new	27
PreCommit1	1342
PreCommit2	1457
PreCommitting	2
PreCommitWait	132
Proving	4387
WaitSeed	64
```

#### 链没有同步，对sector状态的影响

链没有同步，收不到消息反馈，sector就会长时间处于precommitwait。 

链同步了， 有消息反馈了， 

sector会经过 precommitwait -> waitseed -> committing 三个过渡状态。 

10.10.10.206   创世节点
10.10.10.207   跑lotus lotus-server postet
10.10.10.208   跑sealer
10.10.10.209-10.10.10.211   跑P23

10.10.10.212-10.10.10.215   跑P4
10.10.10.17 跑P1 Pc

#### waitseed状态
sector 有waitseed状态的， 可以到task看下这个sector任务停在， 
P3 做完后， 交给P4 阶段， 但这时p4还在忙别的， 这是sector表中看到的壮态就是waitseed状态.

commiting状态

P4 做完之后， 就会打包一个消息发到链上， 链还没有处理完这个消息， 就会停在commting状态， 链处理完这个p4消息， 给本地发个消息， sector就会进入proving状态， 表示上链成功， 随后p6会做清除动作。

PreCommitWait

不能把你的视线依赖于他的视线

xx的用户黏性


####  sealer日志的记录了sector的状态：
```
[root@yangzhou010010012001 log]# cat sealer.log | grep -a 16692481 | grep -v status
2020-06-23T12:02:39.807+0800	INFO	serverapi	serverapi/serverapi.go:231	NewSectorInfo:{"code":0,"msg":"","data":{"sectorID":16692481,"storageNodeID":71,"loc":"nfs/10.10.13.1"}}
2020-06-23T12:02:39.808+0800	INFO	remote-sealer	remote/sealer.go:279	generate new sector {16692481} ...
2020-06-23T12:02:39.821+0800	INFO	sectors	ffsm/garbage.go:25	Pledge {1007 16692481}, contains []
2020-06-23T12:02:39.821+0800	INFO	sectors	ffsm/sealing.go:159	Start sealing 16692481
2020-06-23T12:02:39.824+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: Packing ...
2020-06-23T12:02:39.830+0800	INFO	sectors	ffsm/states.go:19	performing filling up rest of the sector...	{"sector": "16692481"}
2020-06-23T12:02:39.830+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: PreCommit1 ...
2020-06-23T12:02:39.837+0800	INFO	sectors	ffsm/states.go:94	performing sector replication...	{"sector": "16692481"}
2020-06-23T12:02:39.838+0800	DPANIC	sectors	zap@v1.15.0/sugar.go:179	Ignored key without a value.	{"ignored": "16692481"}
2020-06-23T12:02:39.844+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: PreCommit1 ...
2020-06-23T12:02:39.850+0800	INFO	sectors	ffsm/states.go:94	performing sector replication...	{"sector": "16692481"}
2020-06-23T12:02:39.851+0800	INFO	remote-sealer	remote/sealer.go:408	PreCommitPhase1 for sector 16692481 start ...
2020-06-23T12:12:09.872+0800	INFO	remote-sealer	remote/sealer.go:987	PreCommitPhase1 for sector 16692481 elapsed 9m30.020676518s
2020-06-23T12:12:09.872+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: PreCommit2 ...
2020-06-23T12:12:09.895+0800	INFO	remote-sealer	remote/sealer.go:528	PreCommitPhase2 for sector 16692481 start ...
2020-06-23T12:14:09.913+0800	INFO	remote-sealer	remote/sealer.go:987	PreCommitPhase2 for sector 16692481 elapsed 2m0.017911886s
2020-06-23T12:14:09.913+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: PreCommitting ...
2020-06-23T12:14:09.965+0800	INFO	sectors	ffsm/states.go:182	submitting precommit for sector: 16692481
2020-06-23T12:14:09.995+0800	INFO	sectors	ffsm/states.go:188	PreCommitSector msg for sector 16692481: bafy2bzaceavs77ywwdpbjjulyggvmnhzinvplxgsdeyhtahxgoa4fdwttpk4q
2020-06-23T12:14:09.995+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: PreCommitWait ...
2020-06-23T12:14:10.004+0800	INFO	sectors	ffsm/states.go:195	Sector precommitted: 16692481
2020-06-23T12:16:48.232+0800	INFO	sectors	ffsm/states.go:201	wait PreCommitSector msg for sector 16692481: bafy2bzaceavs77ywwdpbjjulyggvmnhzinvplxgsdeyhtahxgoa4fdwttpk4q
2020-06-23T12:16:48.232+0800	INFO	sectors	ffsm/states.go:208	precommit message landed on chain: 16692481
2020-06-23T12:16:48.232+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: WaitSeed ...
2020-06-23T12:20:58.163+0800	INFO	sectors	ffsm/fsm.go:196	Sector 16692481 update state: Committing ...
2020-06-23T12:20:58.219+0800	INFO	sectors	ffsm/states.go:252	KOMIT 16692481 5bf8499ee757de27aeea98cb7f353b686eb7241050f160c0dcb36182badd27bf(1116); d68cd8411aee52218add1c0aeb525c23276ba191573532412e6b7b85bdcdfa6f(2054); [{536870912 bafk4chzahfla46ytve5qpisd7utsb75hzm7b2lsqlkzwfhtz6rrrgujm3ida}]; r:6261666b3465687a61667a62723635746b35377334377063676d3361646e6e6c78337a3575667174646b717332676e6f646a633764686a786c36666b71; d:6261666b3463687a6168666c6134367974766535717069736437757473623735687a6d3762326c73716c6b7a776668747a3672727267756a6d33696461
2020-06-23T12:20:58.219+0800	INFO	remote-sealer	remote/sealer.go:617	CommitPhase1 for sector 16692481 start ...
```

查看链的高度，时间有没有跟上
```
[fil@yangzhou010010011031 ~]$ ./lotus chain list
132: (Jun 27 16:23:02) [ bafy2bzaceatmyooqkrwmturus4gcdtm7rfjtlymlxre4k5rnd3dtukspocbtk: t01000, ]

157: (Jun 27 16:33:27) [ bafy2bzacecjtnhb2yrzp6yntlkmlwgqyzlnnbs3ulcaru22ir7wdmvuxdaqac: t01000, ]
158: (Jun 27 16:33:52) [ bafy2bzacebrjtnknpvrglrevutcgoip7xbyhj5snjjaedu2haayrh2x6ebwpy: t01000, ]
159: (Jun 27 16:34:17) [ bafy2bzacedtkrkxdfgqorndzzggivxiagkypwukkrzu3dxi45pruilkikefeo: t01000, ]
160: (Jun 27 16:34:42) [ bafy2bzacea37fdzmfgbiq5qscaha7psmiwarusokdg7yetn2ecpkc4444oxl4: t01000, ]
161: (Jun 27 16:35:07) [ bafy2bzacebnseyrs4qo4mbgntznd55n6flhnv67bceehhk6ytsihrc7jxnzj4: t01000, ]

```

查看缓冲池里的消息
```
{
  "Message": {
    "Version": 0,
    "To": "t01005",
    "From": "t3wtbioi3c4qoonvj34ibpjkwytqgewgqx6b2djdeolwc7tr2xndjzuhvc3uwimaao4ztssybz674yqimckuoa",
    "Nonce": 3,
    "Value": "0",
    "GasPrice": "1",
    "GasLimit": 1000000,
    "Method": 6,
    "Params": "hgIZAbTYKlgmAAFVwh8g0nfcsJaSrvA6VzgrLOT0OXnOHLyooX49bC1xkSdnAlM5AuKAGgCYnwI="
  },
  "Signature": {
    "Type": 2,
    "Data": "mYup/3kaHUXoUd1l9D/itgauuKIbn1QNr0nCAlyv0OOgrAqm3AShuXJycvNiEJcaGQ+Jg2bsyr15wwUMA1Xl3X8bwJ2BWtBKVVlsPwUAhKQrKwDdbdywaC71qs9qnluO"
  }
}
{
  "Message": {
    "Version": 0,
    "To": "t01005",
    "From": "t3wtbioi3c4qoonvj34ibpjkwytqgewgqx6b2djdeolwc7tr2xndjzuhvc3uwimaao4ztssybz674yqimckuoa",
    "Nonce": 4,
    "Value": "0",
    "GasPrice": "1",
    "GasLimit": 1000000,
    "Method": 6,
    "Params": "hgIZAbXYKlgmAAFVwh8gcZO1s09HOE9AKHwpRtMbCZ/YqJdlTlYPMoB/hOayE245AuKAGgCYnwI="
  },
  "Signature": {
    "Type": 2,
    "Data": "rFIf8KebQK2CPkQmMkhpM6jtOiGHO+Ob9oxB2ai+5X7gG4HLB6WoZF+EtzmBiacjFZ6CqzjOtL8iSClH6PLzVUudJd01IHBrewchwQpnpkJb2UF/AcgL/oyRGZnKjHFi"
  }
}
```


查看pending的消息
```
[fil@yangzhou010010011031 ~]$ ./lotus mpool pending | grep t01005
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
    "To": "t01005",
``` 
    


#### 很多sector长时间处于PreCommitWait， 造成sealer不发任务的排查


    
select state, count(*) from sectors GROUP BY state    
PreCommitWait	  56
    
p2 完成后， 会把消息广播到所有节点， 当某个节点 处理了这个消息， 这个消息会通知本节点的sealer， 这样sealer才会发送task, 没有收到链上的消息反馈， 并且没有完成的Sector已经达到了56个， sealer就不会发任务。 
现在处于等待的sector已经达到56个， 所以task就不会再发消息， 等到链上发回反馈消息后， sector等待的个数小于了56个， sealer就会发新任务了。 

所以要检查消息是否正确的收发

  
```        
[fil@yangzhou010010011031 ~]$ ./lotus-storage-miner info
Mode: poster
Miner: t01005
Sector Size: 512 MiB
Byte Power:   43 GiB / 46.54 GiB (92.3955%)
Actual Power: 43 Gi / 46.9 Gi (91.7027%)
	Committed: 43 GiB
	Proving: 43 GiB
Expected block win rate: 3456.0000/day (every 25s)

Miner Balance: 30.092461805236147744
	PreCommit:   0
	Locked:      26.004648758976302432
	Available:   4.087813046259845312
Worker Balance: 969.907538194761939734
Market (Escrow):  0
Market (Locked):  0
```


断层的


#### poster /mnt 挂错磁盘， 没有和 pc 挂到用一个mnt下， 导致poster读不到pc拷贝过来的文件， 导致poster证明失败


poster.log报错：
```
2020-06-27T19:21:33.205 INFO filcrypto::proofs::api > generate_winning_post: start
2020-06-27T19:21:33.207 INFO filcrypto::proofs::api > generate_winning_post: finish
2020-06-27T19:21:33.207+0800	ERROR	miner	miner/miner.go:165	mining block failed: failed to compute winning post proof:
    github.com/filecoin-project/lotus/miner.(*Miner).mineOne
        /builds/ForceMining/lotus-force/miner/miner.go:343
  - could not read from path="/mnt/nfs/10.10.13.22/cache/s-t01005-524/p_aux"

    Caused by:
        No such file or directory (os error 2)
    github.com/filecoin-project/filecoin-ffi.GenerateWinningPoSt
    	/builds/ForceMining/lotus-force/extern/filecoin-ffi/proofs.go:545
    github.com/filecoin-project/lotus/force/fstorage/fsealmgr/fprover/remote.(*ForceRemoteWDProver).GenerateWinningPoSt
    	/builds/ForceMining/lotus-force/force/fstorage/fsealmgr/fprover/remote/prover.go:76
    github.com/filecoin-project/lotus/storage.(*StorageWpp).ComputeProof
    	/builds/ForceMining/lotus-force/storage/miner.go:204
    github.com/filecoin-project/lotus/miner.(*Miner).mineOne
    	/builds/ForceMining/lotus-force/miner/miner.go:341
    github.com/filecoin-project/lotus/miner.(*Miner).mine
    	/builds/ForceMining/lotus-force/miner/miner.go:163
```


查看poster所在主机的挂载情况： 
```
[fil@yangzhou010010011031 cache]$ df -h
Filesystem                Size  Used Avail Use% Mounted on
/dev/sda4                 1.1T  109G 1004G  10% /
devtmpfs                   63G     0   63G   0% /dev
tmpfs                      63G     0   63G   0% /dev/shm
tmpfs                      63G   27M   63G   1% /run
tmpfs                      63G     0   63G   0% /sys/fs/cgroup
/dev/sda2                 3.9G  112M  3.5G   4% /boot
/dev/sda3                 128M  4.0K  128M   1% /boot/efi
10.10.10.21:/sealer        58T  435G   55T   1% /sealer
tmpfs                      13G     0   13G   0% /run/user/0
10.10.13.22:/mnt/storage   22T  1.6G   21T   1% /mnt
```


重新挂载：
```
mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 10.10.10.21:/mnt/storage  /mnt/
```

重新查看： 
```
[root@yangzhou010010011031 ~]# df -h
文件系统                  容量  已用  可用 已用% 挂载点
/dev/sda4                 1.1T  109G 1004G   10% /
devtmpfs                   63G     0   63G    0% /dev
tmpfs                      63G     0   63G    0% /dev/shm
tmpfs                      63G   27M   63G    1% /run
tmpfs                      63G     0   63G    0% /sys/fs/cgroup
/dev/sda2                 3.9G  112M  3.5G    4% /boot
/dev/sda3                 128M  4.0K  128M    1% /boot/efi
10.10.10.21:/sealer        58T  428G   55T    1% /sealer
tmpfs                      13G     0   13G    0% /run/user/0
10.10.11.21:/mnt/storage  160T  255G  152T    1% /mnt
```


#### 算力高， 但长时间没有出块的原因

因为poster证明有问题， 所以上面poster的 /mnt 挂载错误， 也会导致算力高，不出块的问题。 

所要看./lotus chain list看出块情况， 可以判断poster情况是否正常， 


