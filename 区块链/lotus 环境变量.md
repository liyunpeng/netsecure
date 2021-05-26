
###1. 通用环境变量
```
FIL_PROOFS_PARAMETER_CACHE：proof 证明参数路径，默认在/var/tmp/filecoin-proof-parameters下。
export FIL_PROOFS_PARAMETER_CACHE=/home/user/nvme_disk/filecoin-proof-parameters
FFI_BUILD_FROM_SOURCE：从源码编译底层库。
export FFI_BUILD_FROM_SOURCE=1
IPFS_GATEWAY：配置证明参数下载的代理地址。
export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/
TMPDIR：临时文件夹路径，用于存放显卡锁定文件。
export TMPDIR=/home/user/nvme_disk/tmp
RUST_LOG：配置Rust日志级别。
export RUST_LOG=Debug
GOPROXY：配置Golang代理。
export GOPROXY=https://goproxy.cn
```



### 2. Lotus Deamon环境变量
```
LOTUS_PATH：lotus daemon 路径，例如：
export LOTUS_PATH=/home/user/nvme_disk/lotus
```

### 3. Lotus Miner环境变量
LOTUS_MINER_PATH：lotus miner 路径，例如：
```
export LOTUS_MINER_PATH=/home/user/nvme_disk/lotusminer
FULLNODE_API_INFO：lotus daemon API 环境变量；
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.JSdq-OviNQW2dZslvyargJsqgLrlYCjoZCIFkb2u96g:/ip4/192.168.1.10/tcp/1234/http
BELLMAN_CUSTOM_GPU：指定GPU型号；
```

### 4. Lotus Worker环境变量
```
LOTUS_WORKER_PATH：Lotus worker 路径；
export LOTUS_WORKER_PATH=/home/user/nvme_disk/lotusworker
FIL_PROOFS_MAXIMIZE_CACHING：最大化内存参数；
export FIL_PROOFS_MAXIMIZE_CACHING=1
FIL_PROOFS_USE_MULTICORE_SDR：CPU多核心绑定；
export FIL_PROOFS_USE_MULTICORE_SDR=1
FIL_PROOFS_USE_GPU_TREE_BUILDER：使用GPU计算Precommit2 TREE hash
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
FIL_PROOFS_USE_GPU_COLUMN_BUILDER：使用GUP计算Precommit2 COLUMN hash；
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
BELLMAN_NO_GPU：不使用GPU计算Commit2；
如果要启用 GPU，则不能让这个环境变量（BELLMAN_NO_GPU）出现在系统的环境变量中（env）;
如果它出现在 env 中，则需要使用unset BELLMAN_NO_GPU命令取消，因为设置 export BELLMAN_NO_GPU=0 无效；
export BELLMAN_NO_GPU=1
MINER_API_INFO：Lotus miner的API信息；
export MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.JSdq-OviNQW2dZslvyargJsqgLrlYCjoZCIFkb2u96g:/ip4/192.168.1.10/tcp/1234/http
BELLMAN_CUSTOM_GPU：指定Commit2的GPU型号；
export BELLMAN_CUSTOM_GPU="GeForce RTX 2080 Ti:4352"

```

### ln -s

[fil@miner ~]$ ln -s /home/fil/filecoin-parents /var/tmp/filecoin-parents

[fil@miner ~]$ ln -s /home/fil/filecoin-proof-parameters /var/tmp/filecoin-proof-parameters

### .bashrc 内容
alias p='ps aux | grep'

alias h='history|grep'
export BELLMAN_CPU_UTILIZATION=0.875

使用方便：
![-w808](media/16189892050333.jpg)



### htop

u – 用于显示特定用户拥有的所有进程。

P –用于基于高CPU消耗对进程进行排序。

M –用于基于高内存消耗对进程进行排序。

T –用于根据时间段对过程进行排序。

h –用于打开帮助窗口并查看此处未提及的更多快捷方式。


### winpos post
[fil@miner ~]$ ./lotus-miner sectors list
ID  State    OnChain  Active  Expiration                   Deals
0   Proving  YES      YES     1550150 (in 10 weeks 1 day)  CC
1   Proving  YES      NO      1550150 (in 10 weeks 1 day)  CC
2   Proving  YES      NO      1550150 (in 10 weeks 1 day)  CC
3   Proving  YES      NO      1550150 (in 10 weeks 1 day)  CC
4   Proving  YES      NO      1550150 (in 10 weeks 1 day)  CC
5   Proving  YES      NO      1550150 (in 10 weeks 1 day)  CC
6   Proving  YES      NO      1550150 (in 10 weeks 1 day)  CC

没45分钟证明一次， windowPost, windowPost成功了， active为yes, raw算力才能长上来。 

### Precommit worker 主机设置最大模式
cpu设置为最大模式前， 先看下当前cpu频率：
用cpupower  frequency-info看：
![20210422142429](media/20210422142429.jpg)


用cat /proc/cpuinfo | grep -i "cpu mhz"看：
![-w625](media/16190727537615.jpg)


设置cpu 最大模式： 执行 cpupower -c all frequency-set -g performance 
![-w690](media/16190728101960.jpg)


![20210422142732](media/20210422142732.jpg)
由原来的2.2Ghz 变为 3.6GHz


### 关闭超线程
p1 p2 p4 都要关闭超线程， 因为超出来的线程会来回切
```
[root@instance1 ~]# cat a.sh
#!/bin/bash
for cpunum in $(cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | cut -s -d, -f2- | tr ',' '\n' | sort -un)
do
    echo 0 > /sys/devices/system/cpu/cpu$cpunum/online
done
```
    
    

### 挂载

mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 10.10.10.21:/mnt/storage  /mnt/


### p2 卡在gpu里不动的原因
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
导致p2不能完成， 一直开在这里
![-w896](media/16193338722673.jpg)


### 取消三个环境变量
export BELLMAN_CPU_UTILIZATION=0.875的图：
![-w896](media/16193334894376.jpg)



export BELLMAN_CPU_UTILIZATION=0 （cpu 与 gpu的计算量比） 0表示，cpu完全不计算，  全部由gpu计算
![-w896](media/16193336605418.jpg)



![-w896](media/16193344056827.jpg)


### 完全使用gpu的 p1 p2 c1 c2 winingpost windowpost时间

./lotus-bench sealing --sector-size=2KiB

root用户
BELLMAN_CPU_UTILIZATION=0: 全部用gpu：
![-w896](media/16193345190619.jpg)

root用户
BELLMAN_CPU_UTILIZATION=1: 全部用cpu：
![-w896](media/16193346254969.jpg)


fil用户： 
BELLMAN_CPU_UTILIZATION=0.875， gpu只计算一小部分：
![-w527](media/16193360501240.jpg)
gpu 没有看到曲线


root用户：
![-w848](media/16193364742149.jpg)


### 32G 机械硬盘  window时间

```
2021-04-26T08:59:30.103+0800    ^[[34mINFO^[[0m storageminer    storage/wdpost_run.go:584       running window post     {"chain-random": "t5+Wk8nH6IL0/r8U/C3vclrVf25k8Q6AOcDKhbeQ/mA=", "deadline": {"CurrentEpoch":187419,"PeriodStart":187429,"Index":0,"Open":187429,"Close":187489,"Challenge":187409,"FaultCutoff":187359,"WPoStPeriodDeadlines":48,"WPoStProvingPeriod":2880,"WPoStChallengeWindow":60,"WPoStChallengeLookback":20,"FaultDeclarationCutoff":70}, "height": "187419", "skipped": 0}
2021-04-26T09:37:59.182+0800    ^[[34mINFO^[[0m storageminer    storage/wdpost_run.go:600       computing window post   {"batch": 0, "elapsed": 2309.078367437}
```


### 软连接文件 不能被其他用户访问
![-w952](media/16194171309110.jpg)
