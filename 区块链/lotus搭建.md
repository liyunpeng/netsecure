### 硬件要求
cpu 8 核 amd 架构



### /usr/bin/ld: cannot find -lhwloc 解决办法
![-w572](media/16113923041331.jpg)

解决：
![-w560](media/16113923391766.jpg)


###  centos-安装阿里云的源

文章标签： 运维
版权
查看版本
cat /etc/issue
备份源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
获取源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo 
各版本对应地址:

CentOS 5 : wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
CentOS 6 : wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
CentOS 7 : wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
更新源缓存
清除历史数据

yum clean all

更新最新缓存

yum makecache

### 解决openCl 链接不到的问题

[root@iZuf664ztcz8m5wzm0b0tyZ /]# find -name "*OpenC*"
./opt/intel/opencl/libOpenCL.so
./opt/intel/opencl/libOpenCL.so.1
./opt/intel/opencl/OpenCL.pc
[root@iZuf664ztcz8m5wzm0b0tyZ /]# ln -s /opt/intel/opencl/libOpenCL.so /usr/lib/libOpenCL.so


### sync wait 期间， ./lotus 大小递减
![-w400](media/16128378666146.jpg)


![-w358](media/16128381018408.jpg)


### 下载证明参数文件，速度很快
![-w1706](media/16128385027265.jpg)


### lotus 同步时， .lotus会一会变多， 一会变少

```
# For mainnet only:
lotus daemon --import-snapshot https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car
```
![-w348](media/16128661532011.jpg)


![-w1412](media/16130304225606.jpg)


![-w1412](media/16130304371510.jpg)


![-w1356](media/16130299221185.jpg)



![-w1412](media/16130302905149.jpg)


![-w1412](media/16130307234570.jpg)


![-w1412](media/16130315030523.jpg)


![-w1412](media/16130316348632.jpg)


![-w1412](media/16130320687003.jpg)


![-w1412](media/16130322738133.jpg)


![-w1412](media/16130324949851.jpg)


### lotus 同步浩大量cpu![-w1412](media/16130498834116.jpg)


### swap文件 要256G 
sudo fallocate -l 256G /swapfile

![-w459](media/16130513091434.jpg)


![-w1440](media/16130982874627.jpg)


### owner address 里要有钱， 
```
asEstimateMessageGas error: estimating gas used: CallWithGas failed: call raw get actor: resolution lookup failed (f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova): resolve address f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova: actor not found
2021-02-12T10:48:43.923+0800	INFO	main	lotus-storage-miner/init.go:258	Cleaning up /home/fil/.lotusminer after attempt...
```

给owner address f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova 地址充钱： 
这个地址，虽然在lotus wallet new bls生成了， 但没有交易过， 链上查不到这个地址， 
在gate.io 上充值后， 可以查到这个地址
![-w1440](media/16131119229281.jpg)

金额字段， 显示了这个地址内有多少钱， 
看到会有这样的提示：
```
2021-02-12T14:32:09.094+0800	INFO	build	go-paramfetch@v0.0.2-0.20200701152213-3e0f0afdc261/paramfetch.go:162	parameter and key-fetching complete
2021-02-12T14:32:09.094+0800	INFO	main	lotus-storage-miner/init.go:150	Trying to connect to full node RPC
2021-02-12T14:32:09.095+0800	INFO	main	lotus-storage-miner/init.go:158	Checking full node sync status
Worker: 9505; Base: 493504; Target: 493504 (diff: 0)
State: complete; Current Epoch: 493504; Todo: 0

Done!
2021-02-12T14:32:09.104+0800	INFO	main	lotus-storage-miner/init.go:166	Checking if repo exists
2021-02-12T14:32:09.104+0800	INFO	main	lotus-storage-miner/init.go:182	Checking full node version
2021-02-12T14:32:09.104+0800	INFO	main	lotus-storage-miner/init.go:193	Initializing repo
2021-02-12T14:32:09.104+0800	INFO	repo	repo/fsrepo.go:122	Initializing repo at '/home/fil/.lotusminer'
2021-02-12T14:32:09.105+0800	INFO	main	lotus-storage-miner/init.go:408	Initializing libp2p identity
2021-02-12T14:32:09.111+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-12T14:32:09.127+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-12T14:32:09.324+0800	INFO	main	lotus-storage-miner/init.go:700	Pushed CreateMiner message: bafy2bzacecl3eoejl4d2a73wuxop6gjxtkwfnzab634cdtf3lztnz3ulvjyp6
2021-02-12T14:32:09.324+0800	INFO	main	lotus-storage-miner/init.go:701	Waiting for confirmation
```
等待确认， 要好长时间

发送 创建矿工的消息， 这个消息ID为：bafy2bzacecl3eoejl4d2a73wuxop6gjxtkwfnzab634cdtf3lztnz3ulvjyp6，  需要等待链上确认， 
![-w1440](media/16131124386111.jpg)

长时间没有得到链上确认， 


![-w1381](media/16131128166211.jpg)


因为创建矿工的手续费太高， 而owner address里的钱只有0.11个fil, 导致消息不能上链接。 



### miner set 
```
[fil@machine1 ~]$ ./lotus-miner actor set-addrs /ip4/8.130.54.141/tcp/24001
Requested multiaddrs change in message bafy2bzacecsrlg7uyvowv65fr57522ly2w7sq7reanoypetjug2jyk6jmojz2
```

### nas
![-w1381](media/16133626969534.jpg)


![-w1386](media/16133627219853.jpg)




### .bashrc 文件完整内容：
```
[fil@machine1 ~]$ cat .bashrc
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
export GOROOT=/home/fil/go
export GOPATH=/home/fil/gopath
export GO111MODULE=on
export GOPROXY=https://goproxy.cn

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export PATH=${PATH}:~/go/bin

source "$HOME/.cargo/env"
export BELLMAN_CPU_UTILIZATION=0.875

# See https://github.com/filecoin-project/rust-fil-proofs/
export FIL_PROOFS_MAXIMIZE_CACHING=1 # More speed at RAM cost (1x sector-size of RAM - 32 GB).
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 # precommit2 GPU acceleration
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1

# The following increases speed of PreCommit1 at the cost of using a full
# CPU Core-Complex rather than a single core. Should be used with CPU affinities set!
# See https://github.com/filecoin-project/rust-fil-proofs/ and the seal workers guide.
export FIL_PROOFS_USE_MULTICORE_SDR=1
export TMPDIR=/home/fil/seal-tmp
export BELLMAN_CPU_UTILIZATION=0.875 # Optimal value depends on your exact hardware.
export FIL_PROOFS_MAXIMIZE_CACHING=1
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 # When having GPU.
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1   # When having GPU.
export FIL_PROOFS_PARAMETER_CACHE=/var/tmp/filecoin-proof-parameters/
export FIL_PROOFS_PARENT_CACHE=/home/fil/proof-parent-cache   # > 50GiB!

export LOTUS_WORKER_PATH=/home/fil/work_path
export FIL_PROOFS_USE_MULTICORE_SDR=1
# export MINER_API_INFO="TOKEN:/ip4/8.130.54.141/tcp/24001/http"
export MINER_API_INFO="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.vKziiSHLsC3znNSUEDLv9qNbdRm5oPxoKJvro7H65fU:/ip4/127.0.0.1/tcp/2345/http"

```


### 启动worker

```
[fil@machine1 ~]$ tail -100f lotus-worker.log
2021-02-15T14:38:11.280+0800	INFO	main	lotus-seal-worker/main.go:171	Starting lotus worker
2021-02-15T14:38:11.282+0800	INFO	main	lotus-seal-worker/main.go:216	Remote version 1.4.1+mainnet+git.95e47cf.dirty+api1.0.1
2021-02-15T14:38:11.284+0800	INFO	repo	repo/fsrepo.go:122	Initializing repo at '/home/fil/work_path'
2021-02-15T14:38:11.295+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-15T14:38:11.305+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-15T14:38:11.326+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-15T14:38:11.327+0800	INFO	badger	v2@v2.2007.2/value.go:1158	Replaying file id: 0 at offset: 0

2021-02-15T14:38:11.327+0800	INFO	badger	v2@v2.2007.2/value.go:1178	Replay took: 3.787µs

2021-02-15T14:38:11.337+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-15T14:38:11.338+0800	INFO	badger	v2@v2.2007.2/value.go:1158	Replaying file id: 0 at offset: 0

2021-02-15T14:38:11.338+0800	INFO	badger	v2@v2.2007.2/value.go:1178	Replay took: 1.402µs

2021-02-15T14:38:11.338+0800	INFO	main	lotus-seal-worker/main.go:335	Opening local storage; connecting to master
2021-02-15T14:38:11.339+0800	INFO	main	lotus-seal-worker/main.go:392	Setting up control endpoint at 127.0.0.1:6789
2021-02-15T14:38:11.340+0800	INFO	main	lotus-seal-worker/main.go:495	Making sure no local tasks are running
2021-02-15T14:38:21.346+0800	INFO	main	lotus-seal-worker/main.go:518	Worker registered successfully, waiting for tasks
```


### 改变地址

```
[fil@machine1 ~]$ ./lotus-miner actor set-addrs /ip4/8.130.54.141/tcp/24001
Requested multiaddrs change in message bafy2bzaceceeiqxa4fwsupwk7gkrsbcy36la63im5acsdzg4tvuiwno2ee4iq
```


### miner
miner 断开了， woker报错：
```
2021-02-15T15:16:11.340+0800	ERROR	main	lotus-seal-worker/main.go:502	heartbeat: checking remote session failed: RPC client error: sendRequest failed: Post "http://127.0.0.1:2345/rpc/v0": dial tcp 127.0.0.1:2345: connect: connection refused
2021-02-15T15:16:11.449+0800	WARN	stores	stores/local.go:324	error reporting storage health for 1b81b993-045a-4991-881a-c6336fdb64b9 ({Stat:{Capacity:232381587456 Available:15629103104 Reserved:0} Err:}): RPC client error: sendRequest failed: Post "http://127.0.0.1:2345/rpc/v0": dial tcp 127.0.0.1:2345: connect: connection refused
2021-02-15T15:16:21.340+0800	ERROR	main	lotus-seal-worker/main.go:502	heartbeat: checking remote session failed: RPC client error: sendRequest failed: Post "http://127.0.0.1:2345/rpc/v0": dial tcp 127.0.0.1:2345: connect: connection refused
2021-02-15T15:16:21.449+0800	WARN	stores	stores/local.go:324	error reporting storage health for 1b81b993-045a-4991-881a-c6336fdb64b9 ({Stat:{Capacity:232381587456 Available:15628881920 Reserved:0} Err:}): RPC client error: sendRequest failed: Post "http://127.0.0.1:2345/rpc/v0": dial tcp 127.0.0.1:2345: connect: connection refused
```


### miner链接worke：
miner-log：
```
2021-02-15T15:20:31.341+0800	INFO	stores	stores/index.go:138	New sector storage: 1b81b993-045a-4991-881a-c6336fdb64b9
2021-02-15T15:20:31.342+0800	INFO	node	impl/storminer.go:355	Connected to a remote worker at http://127.0.0.1:6789/rpc/v0
2021-02-15T15:20:31.344+0800	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 4 open windows
2021-02-15T15:20:31.584+0800	WARN	events	events/tscache.go:137	tipSetCache.get: requested tipset not in cache, requesting from storage (h=502240; tail=502241)
```

### 没有配置好环境变量， miner run报错：
```
2021-02-15T15:54:41.331+0800	DEBUG	stores	stores/index.go:396	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, out of space (available: 15119151104, need: 34359738368)
2021-02-15T15:54:41.331+0800	DEBUG	stores	stores/index.go:396	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, out of space (available: 15119151104, need: 34359738368)
2021-02-15T15:54:41.332+0800	ERROR	advmgr	sector-storage/sched.go:404	trySched(1) req.sel.Ok error: finding best alloc storage:
    github.com/filecoin-project/lotus/extern/sector-storage.(*allocSelector).Ok
        /home/fil/lotus-code/extern/sector-storage/selector_alloc.go:55
  - no good path found:
    github.com/filecoin-project/lotus/extern/sector-storage/stores.(*Index).StorageBestAlloc
        /home/fil/lotus-code/extern/sector-storage/stores/index.go:414
2021-02-15T15:54:41.332+0800	ERROR	advmgr	sector-storage/sched.go:404	trySched(1) req.sel.Ok error: finding best alloc storage:
    github.com/filecoin-project/lotus/extern/sector-storage.(*allocSelector).Ok
        /home/fil/lotus-code/extern/sector-storage/selector_alloc.go:55
  - no good path found:
    github.com/filecoin-project/lotus/extern/sector-storage/stores.(*Index).StorageBestAlloc
        /home/fil/lotus-code/extern/sector-storage/stores/index.go:414
2021-02-15T15:54:41.331+0800	DEBUG	stores	stores/index.go:396	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, out of space (available: 15119151104, need: 34359738368)
2021-02-15T15:54:41.332+0800	ERROR	advmgr	sector-storage/sched.go:404	trySched(1) req.sel.Ok error: finding best alloc storage:
    github.com/filecoin-project/lotus/extern/sector-storage.(*allocSelector).Ok
        /home/fil/lotus-code/extern/sector-storage/selector_alloc.go:55
  - no good path found:
    github.com/filecoin-project/lotus/extern/sector-storage/stores.(*Index).StorageBestAlloc
        /home/fil/lotus-code/extern/sector-storage/stores/index.go:414
2021-02-15T15:54:41.333+0800	DEBUG	advmgr	sector-storage/sched.go:449	SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-02-15T15:54:41.333+0800	DEBUG	advmgr	sector-storage/sched.go:450	SCHED Acceptable win: [[] [] []]
```

work_path 空间不够用，只有14G，
将work_path挂载了一个50G盘， 就够用了。 

重启miner， 就可以下发任务了：
```
2021-02-15T16:08:31.544+0800	WARN	advmgr	sector-storage/manager.go:323	stub NewSector
2021-02-15T16:08:31.544+0800	INFO	sectors	storage-sealing/garbage.go:17	Pledge {{168195 7} 8}, contains []
2021-02-15T16:08:31.544+0800	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 4 queued; 4 open windows
2021-02-15T16:08:31.545+0800	DEBUG	advmgr	sector-storage/sched.go:449	SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-02-15T16:08:31.545+0800	DEBUG	advmgr	sector-storage/sched.go:450	SCHED Acceptable win: [[] [] [] []]
```


### sealing workers
```
[fil@machine1 ~]$ ./lotus-miner sealing workers
Worker 29a9eb0e-7f78-4607-9d6e-56d72c8a6f59, host machine1 (disabled)
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.386 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.386 GiB/123.8 GiB
Worker 9ffca929-e969-4eaa-9537-b3726641a535, host machine1
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.187 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.187 GiB/123.8 GiB
```

重启worker：
```
[fil@machine1 ~]$ ./lotus-miner sealing workers
Worker 29a9eb0e-7f78-4607-9d6e-56d72c8a6f59, host machine1 (disabled)
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.386 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.386 GiB/123.8 GiB
Worker 9ffca929-e969-4eaa-9537-b3726641a535, host machine1
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.187 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.187 GiB/123.8 GiB
Worker b94e853f-35d4-4a33-aad1-f27589f0b28e, host machine1
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.381 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.381 GiB/123.8 GiB
```

### miner与worekr通讯log:
```
021-02-15T16:51:21.346+0800	DEBUG	advmgr	sector-storage/sched.go:450	SCHED Acceptable win: [[] [] [] []]
2021-02-15T16:51:31.344+0800	WARN	advmgr	sector-storage/sched_worker.go:213	failed to check worker session	{"error": "RPC client error: sendRequest failed: Post \"http://127.0.0.1:6789/rpc/v0\": dial tcp 127.0.0.1:6789: connect: connection refused"}
2021-02-15T16:51:31.344+0800	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 4 queued; 4 open windows
2021-02-15T16:51:31.344+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.726808536s
2021-02-15T16:51:31.344+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.726848151s
2021-02-15T16:51:31.345+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.726887585s
2021-02-15T16:51:31.345+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.726982973s
2021-02-15T16:51:31.345+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.726890079s
2021-02-15T16:51:31.345+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.727080004s
2021-02-15T16:51:31.344+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.72685295s
2021-02-15T16:51:31.345+0800	DEBUG	stores	stores/index.go:401	not allocating on 1b81b993-045a-4991-881a-c6336fdb64b9, didn't receive heartbeats for 24m49.727191332s
2021-02-15T16:51:31.346+0800	DEBUG	advmgr	sector-storage/sched.go:449	SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-02-15T16:51:31.346+0800	DEBUG	advmgr	sector-storage/sched.go:450	SCHED Acceptable win: [[] [] [] []]
^C
[fil@machine1 ~]$ ./lotus-miner sealing workers
Worker 29a9eb0e-7f78-4607-9d6e-56d72c8a6f59, host machine1 (disabled)
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.386 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.386 GiB/123.8 GiB
Worker 9ffca929-e969-4eaa-9537-b3726641a535, host machine1
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.187 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.187 GiB/123.8 GiB
Worker b94e853f-35d4-4a33-aad1-f27589f0b28e, host machine1
	CPU:  [                                                                ] 0/32 core(s) in use
	RAM:  [||||                                                            ] 7% 9.381 GiB/123.8 GiB
	VMEM: [||||                                                            ] 7% 9.381 GiB/123.8 GiB
[fil@machine1 ~]$
```


### worker起来后， miner run时， miner就能链接到worker设置的端口：
```
2021-02-15T16:53:54.130+0800	INFO	basichost	basic/natmgr.go:91	DiscoverNAT error:no NAT found
2021-02-15T16:54:50.196+0800	INFO	build	go-paramfetch@v0.0.2-0.20200701152213-3e0f0afdc261/paramfetch.go:138	Parameter file /var/tmp/filecoin-proof-parameters/v28-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-0-sha256_hasher-82a357d2f2ca81dc61bb45f4a762807aedee1b0a53fd6c4e77b46a01bfef7820.params is ok
2021-02-15T16:57:36.486+0800	INFO	build	go-paramfetch@v0.0.2-0.20200701152213-3e0f0afdc261/paramfetch.go:138	Parameter file /var/tmp/filecoin-proof-parameters/v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-0377ded656c6f524f1618760bffe4e0a1c51d5a70c4509eedae8a27555733edc.params is ok
2021-02-15T16:57:36.486+0800	INFO	build	go-paramfetch@v0.0.2-0.20200701152213-3e0f0afdc261/paramfetch.go:162	parameter and key-fetching complete
2021-02-15T16:57:39.505+0800	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 0 open windows
2021-02-15T16:57:46.508+0800	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 2 open windows
2021-02-15T16:57:46.518+0800	INFO	storageminer	storage/miner.go:207	starting up miner f0168195, worker addr f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova
2021-02-15T16:57:46.519+0800	INFO	dt-impl	impl/impl.go:182	start data-transfer module
2021-02-15T16:57:46.520+0800	INFO	markets	loggers/loggers.go:56	module ready	{"module": "retrieval provider"}
2021-02-15T16:57:46.522+0800	INFO	markets	loggers/loggers.go:56	module ready	{"module": "storage provider"}
2021-02-15T16:57:46.522+0800	INFO	markets	loggers/loggers.go:56	module ready	{"module": "provider data transfer"}
2021-02-15T16:57:46.522+0800	INFO	main	lotus-storage-miner/run.go:151	Remote version 1.4.1+mainnet+git.3f112d0.dirty+api1.1.0
2021-02-15T16:57:46.523+0800	INFO	markets	loggers/loggers.go:56	module ready	{"module": "piecestore"}
2021-02-15T16:57:46.536+0800	INFO	miner	miner/warmup.go:49	skipping winning PoSt warmup, no sectors
2021-02-15T16:57:53.110+0800	INFO	stores	stores/index.go:138	New sector storage: 417db84a-aeb7-496e-9498-16663771913b
2021-02-15T16:57:53.110+0800	INFO	node	impl/storminer.go:355	Connected to a remote worker at http://127.0.0.1:6606/rpc/v0
2021-02-15T16:57:53.113+0800	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 4 open windows
```




### 删除缓冲池消息

clear  只会删除本地缓冲池里的消息， 链上缓冲池的消息是删除不了的。 

```
[fil@machine1 ~]$ ./lotus mpool  clear --local --really-do-it
[fil@machine1 ~]$
[fil@machine1 ~]$
[fil@machine1 ~]$
[fil@machine1 ~]$ ./lotus mpool pending | grep f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova -A 10 -B 10
[fil@machine1 ~]$ ./lotus mpool pending | grep f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova -A 10 -B 10


./lotus2 mpool repub --from= f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova --from_nonce=15 --to_nonce=5
```


### code
```
[fil@machine1 ~]$ ./lotus state get-actor  f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova
Address:	f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova
Balance:	1.040596965801782546 FIL
Nonce:		2
Code:		bafkqadlgnfwc6mrpmfrwg33vnz2a (fil/2/account)
Head:		bafy2bzacebkejdshuaymcc2xhiqf4affpwley7ievrywldndigkqzr5rxexzs
[fil@machine1 ~]$ ./lotus state get-actor  f0167329
Address:	f0167329
Balance:	0 FIL
Nonce:		0
Code:		bafkqaetgnfwc6mrpon2g64tbm5sw22lomvza (fil/2/storageminer)
Head:		bafy2bzacecq67w6gkjal7extxfjewm2652jwuz4riln4j6l3xdy2021年2月26日3thfeckeok
```

错误： 
```
 ./lotus-miner init --actor=f0168195 --owner=f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova --worker=f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova --no-local-storage > lotus-miner20210215.log 2>&1 &
 
 
 
```
log：

![](media/16142650052316.jpg)


```
2021-02-13T12:27:48.323+0800	INFO	repo	repo/fsrepo.go:122	Initializing repo at '/home/fil/.lotusminer'
2021-02-13T12:27:48.323+0800	INFO	main	lotus-storage-miner/init.go:408	Initializing libp2p identity
2021-02-13T12:27:48.337+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-13T12:27:48.347+0800	INFO	badger	v2@v2.2007.2/levels.go:183	All 0 tables opened in 0s

2021-02-13T12:27:48.353+0800	ERROR	main	lotus-storage-miner/init.go:253	Failed to initialize lotus-miner: failed to configure miner:
    main.storageMinerInit
        /home/fil/lotus-code/cmd/lotus-storage-miner/init.go:518
  - getWorkerAddr returned bad address:
    main.configureStorageMiner
        /home/fil/lotus-code/cmd/lotus-storage-miner/init.go:568
  - failed to load miner actor state: unknown actor code bafkqadlgnfwc6mrpmfrwg33vnz2a
2021-02-13T12:27:48.353+0800	INFO	main	lotus-storage-miner/init.go:258	Cleaning up /home/fil/.lotusminer after attempt...
ERROR: Storage-miner init failed
```

消息池里的消息， 用clear, 只会清除本地缓存， 不会清除链上缓冲池的， 所以不要用clear. 

缓冲里的消息改Nonce要用repub, 即广播到链上缓冲池。需要开发这个功能


### 矿工初始化有actorID， 则会发送changePeerId
```
./lotus-miner init --actor=f0168195 --owner=f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova --worker=f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova --no-local-storage > lotus-miner20210215.log 2>&1 &
```


controller地址诃worker地址要分开
```

 ./lotus-miner init --actor=f0168195 --owner=f3vp5dj3ghe7j6nmx2gkmjzwshp5rvvakh2kebpabngj5id7idh6tsgievwvr2qz5d5tbypu6lrxvxofnrylda --worker=f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova --no-local-storage > lotus-miner20210226.log 2>&1 &
 
   ./lotus send --from f3uqihqemsznet6mce3fvenzyra2a6pet643kqckwiw36zz6eybqii3dx426dnjyakihgxykw3zqrryzexvova f3rlg22zvz6tgdy26urciotphs6n2qytqrqoloopbbzdzcrxifj5azuawltvqevjml2quhpwuxsfbnwrkfcbjq  0.3 
  
```
 

### 初始化矿工成功

```
[fil@machine1 ~]$ cat miner.sh
export FIL_PROOFS_USE_MULTICORE_SDR=1
export TMPDIR=/home/fil/seal-tmp
export BELLMAN_CPU_UTILIZATION=0.875 # Optimal value depends on your exact hardware.
export FIL_PROOFS_MAXIMIZE_CACHING=1
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 # When having GPU.
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1   # When having GPU.
export FIL_PROOFS_PARAMETER_CACHE=/var/tmp/filecoin-proof-parameters/
export FIL_PROOFS_PARENT_CACHE=/home/fil/proof-parent-cache   # > 50GiB!
```
FIL_PROOFS_PARAMETER_CACHE是证明参数存放文件

![-w1432](media/16133572422952.jpg)


lotus 和lotus-minier一起跑耗用的资源：
![-w1020](media/16133576503856.jpg)



### aliyun 云盘停止， ecs服务器 登陆提示如下：
```
[fil@machine1 ~]$ ll /home/fil/seal-tmp
ls: reading directory /home/fil/seal-tmp: Input/output error
total 0
[fil@machine1 ~]$ df /home/fil/work_path
Filesystem     1K-blocks  Used Available Use% Mounted on
/dev/vdc1       51473888 53372  48782744   1% /home/fil/work_path
[fil@machine1 ~]$ ll /home/fil/work_path
ls: reading directory /home/fil/work_path: Input/output error
total 0
```


### 50万的高度， .lotus已经超过100G

```
[fil@machine1 ~]$ du -sch .lotus
100G	.lotus
100G	total
```


### /var/tmp/filcoin. 存放证明参数的文件， 也要单独挂载一个盘： 后面也会超过100G， 而且P4也需要这些证明参数文件

```
[fil@machine1 ~]$ du -sch /var/tmp/filecoin-proof-parameters/
101G	/var/tmp/filecoin-proof-parameters/
101G	total
```




![-w1757](media/16141557005669.jpg)



![-w1757](media/16141586632061.jpg)


### ./lotus-miner info 报bad handshaek
原因：
.bashrc里错误配置了：
export MINER_API_INFO="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.vKziiSHLsC3znNSUEDLv9qNbdRm5oPxoKJvro7H65fU:/ip4/127.0.0.1/tcp/2345/http"
lotus-miner run 时报错： jwc 认证错误


### lotus-worker  报错 
```
2021-02-28T20:59:23.930+0800	WARN	main	lotus-seal-worker/main.go:97	MINER_API_INFO environment variable required to extract IP:
    main.extractRoutableIP
        /home/fil/lotus-code/cmd/lotus-seal-worker/main.go:547
```
原因是没生成 MINER_API_INFO , 用：

```
[fil@machine1 ~]$ ./lotus-miner auth api-info --perm admin
MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.vKziiSHLsC3znNSUEDLv9qNbdRm5oPxoKJvro7H65fU:/ip4/127.0.0.1/tcp/2345/http
```
MINER_API_INFO 放到.bashrc, source一下

然后启动worker, :
```
2021-02-28T21:08:23.269+0800	INFO	main	lotus-seal-worker/main.go:335	Opening local storage; connecting to master
2021-02-28T21:08:23.271+0800	INFO	main	lotus-seal-worker/main.go:392	Setting up control endpoint at 127.0.0.1:6667
2021-02-28T21:08:23.272+0800	INFO	main	lotus-seal-worker/main.go:495	Making sure no local tasks are running
2021-02-28T21:08:33.276+0800	INFO	main	lotus-seal-worker/main.go:518	Worker registered successfully, waiting for tasks
```


### miner
woker 停止， 显示    disabled
```
[fil@m1 ~]$ ./lotus-miner sealing workers
Worker 16c50c3e-bad0-4283-95d7-e43e33e6b89d, host m1
	CPU:  [                                                                ] 0/16 core(s) in use
	RAM:  [||||||||                                                        ] 13% 8.036 GiB/61.76 GiB
	VMEM: [||||||||                                                        ] 13% 8.036 GiB/61.76 GiB
Worker 51834086-4208-4207-987c-32362f1b7497, host m1 (disabled)
	CPU:  [                                                                ] 0/16 core(s) in use
	RAM:  [||||||||                                                        ] 13% 8.247 GiB/61.76 GiB
	VMEM: [||||||||                                                        ] 13% 8.247 GiB/61.76 GiB
```
当worker重新启动后， 
```
[fil@m1 ~]$ ./lotus-miner sealing workers
Worker 16c50c3e-bad0-4283-95d7-e43e33e6b89d, host m1
	CPU:  [                                                                ] 0/16 core(s) in use
	RAM:  [||||||||                                                        ] 13% 8.036 GiB/61.76 GiB
	VMEM: [||||||||                                                        ] 13% 8.036 GiB/61.76 GiB
Worker 9948e6ce-b3ad-45aa-883e-310043636312, host m1
	CPU:  [                                                                ] 0/16 core(s) in use
	RAM:  [||||||||                                                        ] 13% 8.251 GiB/61.76 GiB
	VMEM: [||||||||                                                        ] 13% 8.251 GiB/61.76 GiB
```