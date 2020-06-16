需要的文件如下：
```
[fil@yangzhou010010019017 ~]$ ll
total 321356
-rwxr-xr-x 1 fil fil       382 Jun 13 14:18 config.json
-rwxr-xr-x 1 fil fil       346 Jun 10 19:53 config.toml
drwxr-xr-x 8 fil fil       133 Jun 12 17:12 datastore.bak
-rwxr-xr-x 1 fil fil  35292704 Jun  9 11:23 force-remote-worker
-rwxr-xr-x 1 fil fil 100177939 Jun 12 09:41 lotus
-rwxr-xr-x 1 fil fil  74882880 Jun  9 16:29 lotus-message
-rwxr-xr-x 1 fil fil  18585101 Jun  9 09:29 lotus-server
-rwxr-xr-x 1 fil fil 100112843 Jun 12 09:41 lotus-storage-miner
```

###（一） lotus 链同步
lotus主要是同步链的高度，只有把链的高度同步好以后， 才可以做后续动作， 包括
申请t0地址和t3地址， lotus-message连接， poster,  sealer, remote workder 这些动作。 

lotus把链保存在.lotus/datatore这个文件夹。 

现在链的高度是2万九千多，大概两G多， 如果是第一次，链同步需要大概需要3个小时。 
确定链的起点的过程是远程链和本地链的比较过程，用远程链的最高高度和本地比较， 
所以./lotus sync wait实时看链同步时， 会看到从2万9千多向下递减的过程， 
因为本地链是空的， 所以会一直减到0为止，才完成了起点的确认， 
然后本地链从这个0点， 不断同步远程链， 即本地链不断向上长， 一直到和远程链相同的高度， 
高度和远程链高度相同时， 就同步完成， 可以做后续获取t3地址等的操作。 
用./lotus chain list可以看到最新同步到的链。 

由于同步耗时， 可以把其他主机已经链同步好的.lotus/datastore , 保存到本季的相同目录，减少了链同步时间。 

.lotus目录又lotus进程生成， lotus进程可以随意停止，下次启动还重读文件， 在上次结束的地方继续前进， 

在链同步时， 启动lous的命令可以不带server-api, message-api， 和环境变量的一些参数。 因为这些参数是后需进程配合用的。 

假设当前没有.lotus目录， 
1.  启动lotus , 生成.lotus目录
```
$ nohup ./lotus daemon >lotus.log 2>&1 &
```

2. 结束lotus进程， 把其他主机的.lotus/datastore目录拷贝到本机的.lotus目录下
```
$ ps -ef | grep lotus
$ kill -9 xxx
```

3. 启动lotus， 开时链同步， 
```
$ nohup ./lotus daemon >lotus.log 2>&1 &
$ ./lotus sync wait
$ ./lotus chain list
$ ./lotus sync status 
```
sync status 等看到链高度信息， 表示链同步成功
 
4，结束lotus, 用正式命令启动lotus
```
$ ps -ef | grep lotus
$ kill -9 xxx
$ TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1  nohup ./lotus daemon  --server-api=http://10.10.19.17:3456 --msg-api=http://10.10.19.17:5678/rpc/v0 > lotus.log 2>&1 &
```

### （二） 申请t3地址
t3地址必须放在链同步之后。 后面lotus初始化又依赖于t3地址。 

lotus 高度同步好后， 才可以申请t3地址：
```
[fil@yangzhou010010019017 ~]$ ./lotus wallet list
[fil@yangzhou010010019017 ~]$ ./lotus wallet new bls
t3utkcsylxz6m5wpbjb22uan6ngmj3oqcs2j3tts3ib72nklc7dkq5fjsq3adv3bvia2rrtlqdf2ki6lbwjh7q
```

到网站上申请：
```
https://t01000.miner.interopnet.kittyhawk.wtf/miner.html
```
输入上面new bls 生成的t3地址, 选择出块的大小为512M， 点击 createminer 按钮。 
1分钟左右的时间， 会显示申请到的矿工t0，和t3地址, 得到如下信息： 
```
[CREATING STORAGE MINER]
Gas Funds:   bafy2bzaceb4u5mlywr7lkn4v6rrakgoa7vsz64o7prl752tkeilnt2ge53ffq - OK
Miner Actor: bafy2bzaceb5ypzar6f42phmy5udyb7pp3as7umvcfqhq4w5ink6ruiuf2eo2a - OK
New storage miners address is: t02599
To initialize the storage miner run the following command:
lotus-storage-miner init --actor=t02599 --owner=t3utkcsylxz6m5wpbjb22uan6ngmj3oqcs2j3tts3ib72nklc7dkq5fjsq3adv3bvia2rrtlqdf2ki6lbwjh7q
```
不要运行上面的lotus-storage-miner init --actor=t02599 --owner=t3utkcsylxz6m5wpbjb22uan6ngmj3oqcs2j3tts3ib72nklc7dkq5fjsq3adv3bvia2rrtlqdf2ki6lbwjh7q
这是一个极其漫长的过程

在网站上申请地址好了以后， 这时再看钱包地址，就会看到这个新申请的钱包地址了， 之前wallet list是空的
```
[fil@yangzhou010010019017 ~]$ ./lotus wallet list
t3utkcsylxz6m5wpbjb22uan6ngmj3oqcs2j3tts3ib72nklc7dkq5fjsq3adv3bvia2rrtlqdf2ki6lbwjh7q
```

###（三）lotus 初始化
有了t0，t3地址， 才可以做lutos初始化
初始化会创建.lotusstorage目录，初始化前， 如果有这个目录， 需要删除这个目录。 

```
TRUST_PARAMS=1 ./lotus-storage-miner init --owner=t02599 --nosync  --sector-size 536870912
512M为536870912，32G为34359738368，64G为68719476736。
```

### (四) 启动lotus-message
获取lotus-message启动时需要的network名字
```
[fil@yangzhou010010019017 ~]$ curl http://127.0.0.1:1234/rpc/v0 -X POST -H "Content-Type: application/json" -d '{"method": "Filecoin.StateNetworkName"}'
{"jsonrpc":"2.0","result":"interop"}
```

启动lotus-message:
```
nohup ./lotus-message daemon  --network="interop" > lotus-message.log 2>&1 &
```

正式环境， 应该类似这样的名字： 
```
nohup ./lotus-message daemon  --network="localnet-2f993f25-318f-4d5b-ad87-c79c4ac52806" > lotus-message.log 2>&1 &
```

lotus-message顺序没有要求， 4个进程都是互相独立， 一个进程重启，不需要另一个进程跟着重启。 


### (五) lotus-message 连接到 lotus

获取lotus-message连接的lotus地址
```
$ ./lotus net listen
 /ip4/10.10.1.20/tcp/41613/p2p/12D3KooWNAhSZNdjAGfNvKHbaPu6ToKFydiy6gBKrVVHRYzwfY2e
```

lotus-messae 连接lotus
```
$ ./lotus-message net connect /ip4/10.10.1.20/tcp/41613/p2p/12D3KooWNAhSZNdjAGfNvKHbaPu6ToKFydiy6gBKrVVHRYzwfY2e
```  
lotus每次重启， net listen地址都会变化， 要lotus-message 重新链接


###  (六) 启动poster
```
TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 nohup ./lotus-storage-miner run --mode=remote-wdposter --server-api=http://10.10.1.20:3456 --dist-path=/mnt --nosync > poster.log 2>&1 &
```

###  (七) 启动sealer
```
FORCE_BUILDER_P1_WORKERS=1 FORCE_BUILDER_TASK_DELAY=25m TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 FORCE_BUILDER_TASK_TOTAL_NUM=2 nohup ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.19.17:3456 --dist-path=/mnt --nosync --groups=1 > sealer.log 2>&1
```

### （八） 启动force-remote-worker
RUST_LOG=debug BELLMAN_PROOF_THREADS=3 RUST_BACKTRACE=1 nohup ./force-remote-worker > force-remote-worker.log 2>&1 &



### 换了新的矿工号，要手动修改数据库表

minors表要手动修改， 
然后手动重启lotus ， lotus会读取这个表。 

