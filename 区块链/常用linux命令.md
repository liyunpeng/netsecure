### 版本查看
```
[root@yangzhou010010019017 ~]# cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core)

md5sum 文件名
``` 
### 不同主机之间文件拷贝
```
[root@yangzhou010010001015 20200612]# scp -rpP 62534 * 10.10.19.17:/home/fil
```

mac 开发本的文件 拷贝到 跳板机
```
$ scp -rpP 62534 -i ~/.ssh/id_rsa lotus root@222.189.237.2:/home/ligang/
```

### 配置查看
```
[fil@yangzhou010010001015 ~]$ cat /proc/cpuinfo| grep "cpu cores"| uniq
cpu cores	: 10
[fil@yangzhou010010001015 ~]$ grep MemTotal /proc/meminfo
MemTotal:       32818656 kB

[fil@yangzhou010010019017 ~]$ cat /proc/cpuinfo| grep "cpu cores"| uniq
cpu cores	: 12
[fil@yangzhou010010019017 ~]$  grep MemTotal /proc/meminfo
MemTotal:       131912620 kB
```

### 进程查看
只查看本用户启动的进程
[fil@yangzhou010010019017 ~]$ ps -x


查看所有进程
[fil@yangzhou010010019017 ~]$ ps -ef


### MySQL完整复制表到另一个新表
```
创建新表
CREATE TABLE newuser LIKE user; 

导入数据
INSERT INTO newauser SELECT * FROM user;
```



--------
@yangzhou010010001015 ligang]# scp -rpP 62534 root@10.10.19.19:/home/fil/dev.gen dev.gen
dev.gen                                       100% 4717   988.1KB/s   00:00
[root@yangzhou010010001015 ligang]# ll
总用量 5
-rw-r--r-- 1 root root 4717 6月  18 10:18 dev.gen
drwxr-xr-x 3 root root   43 6月  18 10:01 fengge
drwxr-xr-x 3 root root  102 6月  18 10:33 yanchao


```
[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner init --nosync --sector-size=536870912 owner=t3skxjhibnn3n3mn2zxsyl47ykegodkiffmtm573ypl3iblmhonwdg3hknzlkglv5fshescnltfmg3rgvlqi7a
2020-06-18T13:53:17.946+0800	INFO	main	Initializing lotus storage miner
2020-06-18T13:53:17.946+0800	INFO	main	Checking proof parameters
2020-06-18T13:53:17.947+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-0-sha256_hasher-82a357d2f2ca81dc61bb45f4a762807aedee1b0a53fd6c4e77b46a01bfef7820.vk is ok
2020-06-18T13:53:17.947+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-ecd683648512ab1765faa2a5f14bab48f676e633467f0aa8aad4b55dcb0652bb.vk is ok
2020-06-18T13:53:17.947+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-559e581f022bb4e4ec6e719e563bf0e026ad6de42e56c18714a2c692b1b88d7e.vk is ok
2020-06-18T13:53:17.949+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-5294475db5237a2e83c3e52fd6c2b03859a1831d45ed08c4f35dbf9a803165a9.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0cfb4f178bbb71cf2ecfcd42accce558b27199ab4fb59cb78f2483fe21ef36d9.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-50c7368dea9593ed0989e70974d28024efa9d156d585b7eea1be22b2e753f331.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-032d3138d22506ec0082ed72b2dcba18df18477904e35bafee82b3793b06832f.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0170db1f394b35d995252228ee359194b13199d259380541dc529fb0099096b0.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-3ea05428c9d11689f23529cde32fd30aabd50f7d2c93657c1d3650bca3e8ea9e.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-2-sha256_hasher-96f1b4a04c5c51e4759bbf224bbc2ef5a42c7100f16ec0637123f16a845ddfb2.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-b62098629d07946e9028127e70295ed996fe3ed25b0f9f88eb610a0ab4385a3c.vk is ok
2020-06-18T13:53:17.951+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-7d739b8cf60f1b0709eeebee7730e297683552e4b69cab6984ec0285663c5781.vk is ok
2020-06-18T13:53:17.950+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-6babf46ce344ae495d558e7770a585b2382d54f225af8ed0397b8be7c3fcd472.vk is ok
2020-06-18T13:53:17.957+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-0377ded656c6f524f1618760bffe4e0a1c51d5a70c4509eedae8a27555733edc.vk is ok
2020-06-18T13:53:17.958+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-2627e4006b67f99cef990c0a47d5426cb7ab0a0ad58fc1061547bf2d28b09def.vk is ok
2020-06-18T13:53:18.057+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0cfb4f178bbb71cf2ecfcd42accce558b27199ab4fb59cb78f2483fe21ef36d9.params is ok
2020-06-18T13:53:18.273+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-7d739b8cf60f1b0709eeebee7730e297683552e4b69cab6984ec0285663c5781.params is ok
2020-06-18T13:53:20.645+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-6babf46ce344ae495d558e7770a585b2382d54f225af8ed0397b8be7c3fcd472.params is ok
2020-06-18T13:53:20.646+0800	INFO	build	parameter and key-fetching complete
2020-06-18T13:53:20.646+0800	INFO	main	Trying to connect to full node RPC
2020-06-18T13:53:20.647+0800	INFO	main	Checking full node sync status
2020-06-18T13:53:20.647+0800	INFO	main	Checking if repo exists
2020-06-18T13:53:20.648+0800	INFO	main	Checking full node version
2020-06-18T13:53:20.650+0800	INFO	main	Initializing repo
2020-06-18T13:53:20.650+0800	INFO	repo	Initializing repo at '/home/fil/.lotusstorage'
2020-06-18T13:53:20.651+0800	INFO	main	Initializing libp2p identity
2020-06-18T13:53:20.660+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T13:53:20.663+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T13:53:20.667+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T13:53:20.669+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T13:53:20.672+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T13:53:20.673+0800	INFO	main	Creating StorageMarket.CreateStorageMiner message
2020-06-18T13:53:20.686+0800	INFO	main	Pushed StorageMarket.CreateStorageMiner, bafy2bzacebu3ebperlzz42mfvy34te2crvs5v2gev34yhz5vr4nbrempcizfq to Mpool
2020-06-18T13:53:20.686+0800	INFO	main	Waiting for confirmation

2020-06-18T13:53:34.142+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T13:53:34.142+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T13:53:34.143+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T13:53:34.144+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T13:53:34.144+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T13:53:34.145+0800	ERROR	main	Failed to initialize lotus-storage-miner: creating miner failed:
    main.storageMinerInit
        /builds/ForceMining/lotus-force/cmd/lotus-storage-miner/init.go:504
  - create storage miner failed: exit code 16:
    main.createStorageMiner
        /builds/ForceMining/lotus-force/cmd/lotus-storage-miner/init.go:665
2020-06-18T13:53:34.145+0800	INFO	main	Cleaning up /home/fil/.lotusstorage after attempt...
2020-06-18T13:53:34.147+0800	WARN	main	Storage-miner init failed:
    main.glob..func9
        /builds/ForceMining/lotus-force/cmd/lotus-storage-miner/init.go:248

```

原因是， 创世节点是两k， 其他节点 也要 storage miner时， 也要用两k初始化， 

storage miner init 成功时， 吐的log：
```
[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner init --nosync --sector-size=2048 --owner=t3qr64ae6azjwqewl5ivsyy7dvw73evaerkkiipavd3uqwyz7ybmpp2nxmbfr6r5jgrifmwjq2hnvsclgdpwma
2020-06-18T14:26:59.292+0800	INFO	main	Initializing lotus storage miner
2020-06-18T14:26:59.293+0800	INFO	main	Checking proof parameters
2020-06-18T14:26:59.293+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-2-sha256_hasher-96f1b4a04c5c51e4759bbf224bbc2ef5a42c7100f16ec0637123f16a845ddfb2.vk is ok
2020-06-18T14:26:59.293+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-559e581f022bb4e4ec6e719e563bf0e026ad6de42e56c18714a2c692b1b88d7e.vk is ok
2020-06-18T14:26:59.294+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-5294475db5237a2e83c3e52fd6c2b03859a1831d45ed08c4f35dbf9a803165a9.vk is ok
2020-06-18T14:26:59.294+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0170db1f394b35d995252228ee359194b13199d259380541dc529fb0099096b0.vk is ok
2020-06-18T14:26:59.294+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-50c7368dea9593ed0989e70974d28024efa9d156d585b7eea1be22b2e753f331.vk is ok
2020-06-18T14:26:59.297+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-6babf46ce344ae495d558e7770a585b2382d54f225af8ed0397b8be7c3fcd472.vk is ok
2020-06-18T14:26:59.298+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-b62098629d07946e9028127e70295ed996fe3ed25b0f9f88eb610a0ab4385a3c.vk is ok
2020-06-18T14:26:59.298+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-032d3138d22506ec0082ed72b2dcba18df18477904e35bafee82b3793b06832f.vk is ok
2020-06-18T14:26:59.297+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-3ea05428c9d11689f23529cde32fd30aabd50f7d2c93657c1d3650bca3e8ea9e.vk is ok
2020-06-18T14:26:59.298+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-7d739b8cf60f1b0709eeebee7730e297683552e4b69cab6984ec0285663c5781.vk is ok
2020-06-18T14:26:59.298+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-ecd683648512ab1765faa2a5f14bab48f676e633467f0aa8aad4b55dcb0652bb.vk is ok
2020-06-18T14:26:59.297+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0cfb4f178bbb71cf2ecfcd42accce558b27199ab4fb59cb78f2483fe21ef36d9.vk is ok
2020-06-18T14:26:59.298+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-0-sha256_hasher-82a357d2f2ca81dc61bb45f4a762807aedee1b0a53fd6c4e77b46a01bfef7820.vk is ok
2020-06-18T14:26:59.304+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-2627e4006b67f99cef990c0a47d5426cb7ab0a0ad58fc1061547bf2d28b09def.vk is ok
2020-06-18T14:26:59.305+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-0377ded656c6f524f1618760bffe4e0a1c51d5a70c4509eedae8a27555733edc.vk is ok
2020-06-18T14:26:59.322+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0170db1f394b35d995252228ee359194b13199d259380541dc529fb0099096b0.params is ok
2020-06-18T14:26:59.404+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-3ea05428c9d11689f23529cde32fd30aabd50f7d2c93657c1d3650bca3e8ea9e.params is ok
2020-06-18T14:27:00.759+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-032d3138d22506ec0082ed72b2dcba18df18477904e35bafee82b3793b06832f.params is ok
2020-06-18T14:27:00.760+0800	INFO	build	parameter and key-fetching complete
2020-06-18T14:27:00.760+0800	INFO	main	Trying to connect to full node RPC
2020-06-18T14:27:00.760+0800	INFO	main	Checking full node sync status
2020-06-18T14:27:00.760+0800	INFO	main	Checking if repo exists
2020-06-18T14:27:00.761+0800	INFO	main	Checking full node version
2020-06-18T14:27:00.763+0800	INFO	main	Initializing repo
2020-06-18T14:27:00.763+0800	INFO	repo	Initializing repo at '/home/fil/.lotusstorage'
2020-06-18T14:27:00.764+0800	INFO	main	Initializing libp2p identity
2020-06-18T14:27:00.771+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T14:27:00.775+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T14:27:00.780+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T14:27:00.785+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T14:27:00.789+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T14:27:00.790+0800	INFO	main	Creating StorageMarket.CreateStorageMiner message
2020-06-18T14:27:00.803+0800	INFO	main	Pushed StorageMarket.CreateStorageMiner, bafy2bzacec5nky3by6u6respw2cgjw5r3tq57ufzk3hdyc3hoz4u2ln6w3h7c to Mpool
2020-06-18T14:27:00.804+0800	INFO	main	Waiting for confirmation
2020-06-18T14:27:14.146+0800	INFO	main	New storage miners address is: t01003 (t2diqcict6ti55xltgicac433ywbvckwpvxi6rbgi)
2020-06-18T14:27:14.146+0800	INFO	main	Created new storage miner: t01003
2020-06-18T14:27:14.148+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T14:27:14.149+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T14:27:14.150+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T14:27:14.151+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T14:27:14.152+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T14:27:14.152+0800	INFO	main	Storage miner successfully created, you can now start it with 'lotus-storage-miner run'
```

其中， 显示了 生成的t0地址
```
2020-06-18T14:27:14.146+0800	INFO	main	Created new storage miner: t01003
```


### root用户下 初始化 sealer

sealer 在root用户下运行， 需要初始化， 
./lotus-storage-miner init  --nosync --owner=t0地址
注意owner是t0

```
[root@yangzhou010010019017 ~]# ./lotus-storage-miner init  --nosync --owner=t01003
2020-06-18T15:47:14.859+0800	INFO	main	Initializing lotus storage miner
2020-06-18T15:47:14.859+0800	INFO	main	Checking proof parameters
2020-06-18T15:47:14.860+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-6babf46ce344ae495d558e7770a585b2382d54f225af8ed0397b8be7c3fcd472.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-0-sha256_hasher-82a357d2f2ca81dc61bb45f4a762807aedee1b0a53fd6c4e77b46a01bfef7820.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-3ea05428c9d11689f23529cde32fd30aabd50f7d2c93657c1d3650bca3e8ea9e.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-5294475db5237a2e83c3e52fd6c2b03859a1831d45ed08c4f35dbf9a803165a9.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-b62098629d07946e9028127e70295ed996fe3ed25b0f9f88eb610a0ab4385a3c.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-559e581f022bb4e4ec6e719e563bf0e026ad6de42e56c18714a2c692b1b88d7e.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0cfb4f178bbb71cf2ecfcd42accce558b27199ab4fb59cb78f2483fe21ef36d9.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-50c7368dea9593ed0989e70974d28024efa9d156d585b7eea1be22b2e753f331.vk is ok
2020-06-18T15:47:14.864+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-032d3138d22506ec0082ed72b2dcba18df18477904e35bafee82b3793b06832f.vk is ok
2020-06-18T15:47:14.864+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-2-sha256_hasher-96f1b4a04c5c51e4759bbf224bbc2ef5a42c7100f16ec0637123f16a845ddfb2.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-7d739b8cf60f1b0709eeebee7730e297683552e4b69cab6984ec0285663c5781.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0170db1f394b35d995252228ee359194b13199d259380541dc529fb0099096b0.vk is ok
2020-06-18T15:47:14.863+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-ecd683648512ab1765faa2a5f14bab48f676e633467f0aa8aad4b55dcb0652bb.vk is ok
2020-06-18T15:47:14.870+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-0377ded656c6f524f1618760bffe4e0a1c51d5a70c4509eedae8a27555733edc.vk is ok
2020-06-18T15:47:14.870+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-2627e4006b67f99cef990c0a47d5426cb7ab0a0ad58fc1061547bf2d28b09def.vk is ok
2020-06-18T15:47:14.898+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0170db1f394b35d995252228ee359194b13199d259380541dc529fb0099096b0.params is ok
2020-06-18T15:47:14.976+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-3ea05428c9d11689f23529cde32fd30aabd50f7d2c93657c1d3650bca3e8ea9e.params is ok
2020-06-18T15:47:16.388+0800	INFO	build	Parameter file /var/tmp/filecoin-proof-parameters/v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-032d3138d22506ec0082ed72b2dcba18df18477904e35bafee82b3793b06832f.params is ok
2020-06-18T15:47:16.388+0800	INFO	build	parameter and key-fetching complete
2020-06-18T15:47:16.388+0800	INFO	main	Trying to connect to full node RPC
2020-06-18T15:47:16.389+0800	INFO	main	Checking full node sync status
2020-06-18T15:47:16.389+0800	INFO	main	Checking if repo exists
2020-06-18T15:47:16.389+0800	INFO	main	Checking full node version
2020-06-18T15:47:16.391+0800	INFO	main	Initializing repo
2020-06-18T15:47:16.391+0800	INFO	repo	Initializing repo at '/root/.lotusstorage'
2020-06-18T15:47:16.392+0800	INFO	main	Initializing libp2p identity
2020-06-18T15:47:16.398+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T15:47:16.405+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T15:47:16.409+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T15:47:16.412+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T15:47:16.417+0800	INFO	badger	All 0 tables opened in 0s

2020-06-18T15:47:16.418+0800	INFO	main	Creating StorageMarket.CreateStorageMiner message
2020-06-18T15:47:16.418+0800	INFO	main	get address of protocol ID ,inject
2020-06-18T15:47:16.418+0800	INFO	main	Created new storage miner: t01003
2020-06-18T15:47:16.419+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T15:47:16.419+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T15:47:16.420+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T15:47:16.421+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T15:47:16.421+0800	INFO	badger	Got compaction priority: {level:0 score:1.73 dropPrefix:[]}
2020-06-18T15:47:16.422+0800	INFO	main	Storage miner successfully created, you can now start it with 'lotus-storage-miner run'
```