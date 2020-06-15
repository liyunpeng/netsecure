### 初始化主要把矿工相应的信息提交到区块链
拿到矿工号， 就为poster， sealer做初始化: 
初始化主要把矿工相应的信息提交到区块链，如果上链成功的话(这个过程将花费 30-60s)，此命令应成功返回。
```
TRUST_PARAMS=1 ./lotus-storage-miner init --owner=t01004 --nosync  --sector-size 34359738368
```
#### 初始化的参数
--owner=t01004 矿工号
--sector-size 34359738368 出块的大小
512M为536870912，32G为34359738368，64G为68719476736。


### 启动sealer
sealer 一般在另一台主机启动， 这里为学习方便， 用本机的root用户启动 sealer
要注意端口号的重复
启动sealer
```
FORCE_BUILDER_P1_WORKERS=1 FORCE_BUILDER_TASK_DELAY=25m TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 FORCE_BUILDER_TASK_TOTAL_NUM=2 nohup ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.19.17:3456 --dist-path=/mnt --nosync --groups=1 > sealer.log 2>&1 &
```

#### 启动searler的参数
FORCE_BUILDER_P1_WORKERS 不必和config.toml中的有PreCommitPhase1的worker数目相同
[[worker]]
num = 1
supported_phase = ["PreCommitPhase1","PreCommitPhase2","CommitPhase1","CommitPhase2"]
wait_sec = 60

config.toml设置为1， FORCE_BUILDER_P1_WORKERS可以设置为1-

FORCE_BUILDER_TASK_TOTAL_NUM  一般是 FORCE_BUILDER_P1_WORKERS  的2倍加1 

