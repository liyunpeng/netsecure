### mac 上的实验数据：
####  1. 获取证明参数文件
```
./lotus fetch-params --proving-params 2048

du -sch /var/tmp/filecoin-proof-parameters/
1.1G	/var/tmp/filecoin-proof-parameters/
1.1G	total
```

#### 2.  seed pre-seal 
pre-seal 成功的正常log: 
```
➜  lotustest ./lotus-seed pre-seal --sector-size 2048  --num-sectors 5
sector-id: {1000 0}, piece info: {2048 bafk4chzaikpr46qbf6tdjufoozqrejzsqkk66i7stavvrx5oktgt2wskx45a}
2020-06-21T15:59:45.961+0800	WARN	preseal	seed/seed.go:100	PreCommitOutput: {1000 0} bafk4ehzaavtxkpfnlv25qsgy7u7ripuxap5zprnirqejfumbb5zmuddtrffa bafk4chzaikpr46qbf6tdjufoozqrejzsqkk66i7stavvrx5oktgt2wskx45a
sector-id: {1000 1}, piece info: {2048 bafk4chzacil7x45ioxpbj3xz7r4hmo4qjtljphnkk4z6etpevrjoc53z7amq}
2020-06-21T15:59:45.991+0800	WARN	preseal	seed/seed.go:100	PreCommitOutput: {1000 1} bafk4ehzan2g7xntx2umacevdnct5izwkivtdpbzpafzwz2zpamrdkvastria bafk4chzacil7x45ioxpbj3xz7r4hmo4qjtljphnkk4z6etpevrjoc53z7amq
sector-id: {1000 2}, piece info: {2048 bafk4chzavsaszg2v5zz3th25igbssj7t6vkyssnlgafxc5i4nppls7fveima}
2020-06-21T15:59:46.020+0800	WARN	preseal	seed/seed.go:100	PreCommitOutput: {1000 2} bafk4ehzamnrezpu4c57bev234fbzupx4vuk2kjaceqngb4cl3fuux3g6gjxq bafk4chzavsaszg2v5zz3th25igbssj7t6vkyssnlgafxc5i4nppls7fveima
sector-id: {1000 3}, piece info: {2048 bafk4chzad2ttxc7fxiemr6sircdhglc6mhn5nmpraluojsnq5aadglnf6q6a}
2020-06-21T15:59:46.050+0800	WARN	preseal	seed/seed.go:100	PreCommitOutput: {1000 3} bafk4ehzayocllxmkwc4xpnkkza2iqtz6vtn3j3gjthgo6qmxmurwdgwe7ngq bafk4chzad2ttxc7fxiemr6sircdhglc6mhn5nmpraluojsnq5aadglnf6q6a
sector-id: {1000 4}, piece info: {2048 bafk4chzam6iqpjl6l62ol4grofo2dt5sc3svtoigr6il55y4y7e64ic6cepa}
2020-06-21T15:59:46.080+0800	WARN	preseal	seed/seed.go:100	PreCommitOutput: {1000 4} bafk4ehzahjvfltfyxoooj4vwakwavwe4xajec3e27q7waposkugn3lhicjhq bafk4chzam6iqpjl6l62ol4grofo2dt5sc3svtoigr6il55y4y7e64ic6cepa
2020-06-21T15:59:46.081+0800	WARN	preseal	seed/seed.go:124	PeerID not specified, generating dummy
2020-06-21T15:59:46.082+0800	INFO	preseal	seed/seed.go:179	Writing preseal manifest to /Users/zhenglun1/.genesis-sectors/pre-seal-t01000.json
```

#### 3. genesis new 生成.genesis-sectors目录
```
./lotus-seed genesis new localnet.json
在用户跟目录下生成 .genesis-sectors 目录 
➜  lotustest ll -a ~/.genesis-sectors
total 32
drwxr-xr-x   8 zhenglun1  staff   256B  6 21 15:59 .
drwxr-xr-x+ 48 zhenglun1  staff   1.5K  6 21 16:03 ..
drwxr-xr-x   7 zhenglun1  staff   224B  6 21 15:59 cache
-rw-r--r--   1 zhenglun1  staff   4.3K  6 21 15:59 pre-seal-t01000.json
-rw-r--r--   1 zhenglun1  staff   148B  6 21 15:59 pre-seal-t01000.key
drwxr-xr-x   7 zhenglun1  staff   224B  6 21 15:59 sealed
-rw-r--r--   1 zhenglun1  staff   106B  6 21 15:59 sectorstore.json
drwxr-xr-x   7 zhenglun1  staff   224B  6 21 15:59 unsealed
```
#### 4. 创建创世节点矿工
```
➜  lotustest ./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json
2020-06-21T16:04:38.653+0800	INFO	lotus-seed	lotus-seed/genesis.go:107	Adding miner t01000 to genesis template
2020-06-21T16:04:38.653+0800	INFO	lotus-seed	lotus-seed/genesis.go:124	Giving t3u6gvbw35viq3q66tfxyc6nh3igs74trvxmfai2bs275ka7lcvlt5cbisugaew3exd72avgtlkaaxmfqdy3ua some initial balance
```

#### 5. 运行 lotus daemon
#####  1. Allowance 10240 below MinVerifiedDealSize. 错误排查
```
nohup ./lotus daemon --lotus-make-genesis=dev.gen --genesis-template=localnet.json --bootstrap=false > lotus.log 2>&1 &
```

lotus 没起来 ， lotus.log 末尾看到的错误

```
2020-06-21T16:40:55.322+0800	WARN	main	lotus/main.go:81	initializing node:
    main.glob..func2
        /Users/zhenglun1/goworkspace/lotus/lotus/cmd/lotus/daemon.go:231
  - starting node:
    github.com/filecoin-project/lotus/node.New
        /Users/zhenglun1/goworkspace/lotus/lotus/node/builder.go:492
  - could not build arguments for function "github.com/filecoin-project/lotus/node/modules/lp2p".StartListening.func1 (/Users/zhenglun1/goworkspace/lotus/lotus/node/modules/lp2p/addrs.go:98): failed to build host.Host: 

could not build arguments for function "reflect".makeFuncStub (/Users/zhenglun1/goroot/go/src/reflect/asm_amd64.s:12): 

failed to build lp2p.BaseIpfsRouting: could not build arguments for function "reflect".makeFuncStub (/Users/zhenglun1/goroot/go/src/reflect/asm_amd64.s:12): 

failed to build dtypes.NetworkName: could not build arguments for function "reflect".makeFuncStub (/Users/zhenglun1/goroot/go/src/reflect/asm_amd64.s:12): 

failed to build dtypes.AfterGenesisSet: function "reflect".makeFuncStub (/Users/zhenglun1/goroot/go/src/reflect/asm_amd64.s:12) returned a non-nil error: 

genesis func failed: make genesis block: failed to verify presealed data: failed to add verified client: 

doExec apply message failed: Allowance 10240 below MinVerifiedDealSize for add verified client t3tahdt24chfchkzgk7mmhtakfc2mvilifdluru4rvc7cg7kbwgtcw5kxqjq42ydnxo3xnrgebsmrfkxuiun7q (RetCode=16)
```

#### import 创世节点的key

```
➜  lotustest ./lotus wallet import ~/.genesis-sectors/pre-seal-t01000.key
imported key t3u6gvbw35viq3q66tfxyc6nh3igs74trvxmfai2bs275ka7lcvlt5cbisugaew3exd72avgtlkaaxmfqdy3ua successfully!
```
