拿到矿工号， 就可以初始化poster或sealer: 

```
TRUST_PARAMS=1 ./lotus-storage-miner init --owner=t01004 --nosync  --sector-size 34359738368
```

512M为536870912，32G为34359738368，64G为68719476736。

这条命令把矿工相应的信息提交到区块链，如果上链成功的话(这个过程将花费 30-60s)，此命令应成功返回。

sealer 一般在另一台主机启动， 这里为学习方便， 用本季的root用户启动 sealer
要注意端口号的重复
启动sealer
>| FORCE_BUILDER_P1_WORKERS=1 FORCE_BUILDER_TASK_DELAY=25m TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 FORCE_BUILDER_TASK_TOTAL_NUM=2 nohup ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.19.17:3456 --dist-path=/mnt --nosync --groups=1 > sealer.log 2>&1 &

