[TOC]

### 内网拷贝速度 nvme盘， 考到另一个主机， 100多MB/s的速度

### 编译 lotus
Some newer CPU architectures like AMD's Zen and Intel's Ice Lake, have support for SHA extensions. Having these extensions enabled significantly speeds up your Lotus node. To make full use of your processor's capabilities, make sure you set the following variables before building from source:
```
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1
```
This method of building does not produce portable binaries. Make sure you run the binary on the same computer as you built it.
``
給amd用的， 用这个编译命令： 
```
RUSTFLAGS="-C target-cpu=native -g" FFI_BUILD_FROM_SOURCE=1 make clean all
```

make calibnet

ulimit -SHn 65535

### rust 安装
Lotus needs rustup (opens new window). The easiest way to install it is

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

要用root身份安装



### 钱包的文件方式导出 

lotus节点下的keystore 文件夹，存放了私钥， 被拷贝到， 就等于私钥被烤出来了。 

```
[fil@localhost ~]$ scp root@192.168.0.220:/home/fil/.lotus/keystore/O5QWY3DFOQWXIM3XOJQXSZDPGRYXS2DBMVWHU5TGNRVG6NTEGN3HAYLYOUZXQYLLGNYDE4TQGJUXC4LONNYWG2DKM5ZGMY3NG5THM2JXGJ4GU2TXNJ3GMYLIMFSXIYTONUZWM2TPNVWHS4ZVMZ4WC .lotus/keystore/
root@192.168.0.220's password:
O5QWY3DFOQWXIM3XOJQXSZDPGRYXS2DBMVWHU5TGNRVG6NTEGN3HAYLYOUZXQYLLGNYDE4TQGJUXC4LONNYWG2DKM5Z 100%   74    34.5KB/s   00:00
[fil@localhost ~]$ ./lotus wallet list
Address                                                                                 Balance                          Nonce  Default
t3v3arnuhbuogo2wfqvidtamqvbzzzifukrlpz3norhxs35u77c74e7iusk672zy6ikahdv22hsloqtelfl2ma  49998999.999759830827908636 FIL  140    X
t3wraydo4qyhaelzvfljo6d3vpaxu3xak3p2rp2iqqnkqchjgrfcm7fvi72xjjwjvfahaetbnm3fjomlys5fya  0 FIL                            0
```

t3wraydo4qyhaelzvfljo6d3vpaxu3xak3p2rp2iqqnkqchjgrfcm7fvi72xjjwjvfahaetbnm3fjomlys5fya 这个钱包就被导入了。 




### calibration地址
[fil@localhost ~]$ ./lotus wallet list
Address                                                                                 Balance  Nonce  Default
t1vmzdkcqsupqe4bgvvededrcqz7d74y5iaghbfca                                               0 FIL    0
t3tdcjrowljtbsv5d5poqwzhgyhsyuzlycur2ngr2rmecsxvgrrcldyjgnjqf3srf4kxcuepiwrwonuuweeh3q  0 FIL    0
t3wcktdwxdmididz57ni2wcttoxss3byuzjl7xosyciqogdbavkz5vss7rgx4lfxhzgqufootdrtu5oaw73ema  0 FIL    0      X

Filscan Filwallet 开发， 维护


[fil@localhost ~]$ ./lotus wallet list
Address                                                                                 Balance  Nonce  Default``
t1vmzdkcqsupqe4bgvvededrcqz7d74y5iaghbfca                                               0 FIL    0
t3tdcjrowljtbsv5d5poqwzhgyhsyuzlycur2ngr2rmecsxvgrrcldyjgnjqf3srf4kxcuepiwrwonuuweeh3q  0 FIL    0
t3uyzsriie73tzqk4qvrmt2ipmmyr3cnjz6nadybblnqclib3hbj5f4r7hewoqjpueg4u2bxsvyosowizeyrva  0 FIL    0
t3wcktdwxdmididz57ni2wcttoxss3byuzjl7xosyciqogdbavkz5vss7rgx4lfxhzgqufootdrtu5oaw73ema  0 FIL    0      X


水龙头， 怎么申请到fil


### ssh 签名文件错误：
192.168.0.3 已经不是原来的主机。 
![-w821](media/16186260787262.jpg)
解决方法：
mac 主机删除.ssh/known_hosts中192.168.0.3的那一行



### lotus 状态变化

sector 依次经历几个状态：
PreCommitWait  cpu 一点
WaitSeed  cpu 一点
Committing  cpu 全满跑
CommitWait cpu 一点
FinalizeSector 
Proving

状态含义:

| 状态 | 含义| 512M 持续时间
|---|---|---|
new |
PreCommit1 | 正在做P1  | 
PreCommit2 | 正在做P2  |
PreCommitting | 
PreCommitWait | p2 消息已经发出， 但没收到链上对该消息的回复
WaitSeed | p2消息已经发出，而且也得到了链上的回复，等待P3来领任务
Committing | P3 P4 正在封装进行中  |
CommitWait | p4的本地验证已经ok, 并且p4的消息已经发出， 但还没有得到链上回复
FinalizeSector |  
Proving |  p4消息已经发出,链上已回复，上链完成
FinalizeSector |  

committing 包括了p3, p4. 还有p4做完后， sealer还在验证的事情。 

P4
commitwait 说明 P4已经做完， 


commitwait 就是onchain状体了
![-w552](media/16182918506060.jpg)



### miner上看worker cpu, 内存， 虚拟内存
![-w865](media/16184495948372.jpg)

```
Worker 41a9b831-f14b-409f-9e56-1ee760fba9f6, host 145 (disabled)
	CPU:  [                                                                ] 0/4 core(s) in use
	4核
	RAM:  [|||                                                             ] 5% 946.4 MiB/15.41 GiB
	物理内存 16G
	VMEM: [||                                                              ] 3% 946.4 MiB/23.22 GiB
	物理内存加swap内存 共 24G
```
### 硬件要求
cpu 8 核 amd 架构

### ssh 免密码登陆
A 登陆到 B

B 新建文件： 
.ssh/authorized_keys
将A的.ssh/id_rsa.pub 贴到 B的 .ssh/authorized_keys 文件里，就可以了

### connnect 连创世节点， 连不上，
解决： 创世节点 iptables -F 
### /usr/bin/ld: cannot find -lhwloc 解决办法
![-w572](media/16113923041331.jpg)

解决：
![-w560](media/16113923391766.jpg)


### lotus-miner 与 lotus 在单独的一台机器上运行
lotus daemon 不指定 --api， 就用.lotus/config.tml， 改为：

```
[API]
  ListenAddress = "/ip4/192.168.0.220/tcp/1234/http"
  RemoteListenAddress = "192.168.0.2"
    #  Timeout = "30s"
```

192.168.0.220 为本lotus节点主机的ip
192.168.0.2 为创世节点ip， 
重启命令：
nohup ./lotus daemon --genesis=./dev.gen > lotus.log 2>&1 &

[fil@220 ~]$ cat .lotus/api
/ip4/192.168.0.220/tcp/1234/http

![-w962](media/16182099606644.jpg)
会看到有1234端口监听服务

lous 的api  token同步到 miner机器上的.lotus/文件夹下：

lotus miner 就成功连接到 lotus， 成功初始化：
```
[fil@miner ~]$ ./lotus-miner init --nosync --sector-size=2048 --owner=t3vmmjc6pw4eh4khjp6jr4gwoiqv4etcvaq64hkg2hwdupczydnkxwk4kxuud4nnuh6ekb6h262ph5nk2tncka
。。。。
2021-04-12T02:37:20.079-0400	INFO	main	lotus-storage-miner/init.go:717	New miners address is: t01002 (t2oaue7w4qrsvw4yvh2trkixqlvkxyff5x2r2yy5i)
2021-04-12T02:37:20.079-0400	INFO	main	lotus-storage-miner/init.go:531	Created new miner: t01002
2021-04-12T02:37:20.084-0400	INFO	main	lotus-storage-miner/init.go:266	Miner successfully created, you can now start it with 'lotus-miner run'
``` 

### lotus 误删除的解决办法
将创世节点的 .lotus文件夹 同步到 本地
将miner的.lotus 的api， token 同步到本地的.lotus中


### CentOS7系统 ping 不过的问题

参照博客http://www.cnblogs.com/wcwen1990/p/7630545.html安装CentOS7系统(本人的CentOS7虚拟机命名为CentOS7_64)

开启CentOS7_64虚拟机,并使用root账户登录成功后使用vi命令网络配置文件

1) 输入命令 vi /etc/sysconfig/network-scripts/ifcfg-ens33 进入网络配置文件

2) 按 i 键进入编辑模式输入上图中的网络配置键值对参数，然后依次：按esc键->输入“:wq”->回车

保存网络配置；

3）输入命令：service network restart


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

### 解决因peer端口没开， lotus sync wait 卡住的问题

问题现象：
lotus sync wait 卡住
![-w267](media/16181909644648.jpg)
没有net connet ， 也会sync wait  卡住， 
这里  connet 失败， 也会sync wait  卡住, 没有输出， ctrl c 也结束不了

220 机器上 找不到端口 40653 
![-w545](media/16180288552330.jpg)

connect 连不上
![-w889](media/16180288896199.jpg)


到2 上操作：
![-w734](media/16180289881315.jpg)
lotus 监听40653 端口， 即这个端口有服务

![-w857](media/16180290361173.jpg)

解决： 
防火墙打开端口：
![-w680](media/16180290795728.jpg)
sudo firewall-cmd --zone=public --add-port=40653/tcp --permanent
生效：
sudo firewall-cmd --reload

再到220上测试：
![-w427](media/16180291417757.jpg)

再次链接：
![-w892](media/16180291657454.jpg)

lotus sync wait 就不会卡住了， 正常同步了

###  miner 报 钱不够， 导致消息不能上链

```
2021-04-14T07:59:05.017-0400    ^[[34mINFO^[[0m sectors storage-sealing/states_sealing.go:316   submitting precommit for sector 20 (deposit: 1395579022178119777890):
2021-04-14T07:59:05.020-0400    ^[[33mWARN^[[0m sectors storage-sealing/fsm.go:542      sector 20 got error event sealing.SectorChainPreCommitFailed: pushing message to mpool: GasEstimateMessageGas error: estimating gas used: message execution failed: exit SysErrInsufficientFunds(6), reason: failed to transfer funds (RetCode=6): transfer failed when deducting funds (1395.57902217811977789 FIL): not enough funds (RetCode=6)
2021-04-14T07:59:05.022-0400    ^[[33mWARN^[[0m storageminer    storage/addresses.go:144        address didn't have enough funds to send message        {"address": "t01001", "required": "1395.60402217811977789 FIL", "balance": "999.892595676772660921 FIL"}
```


### lotus 节点防火墙 把所有端口禁止了， 导致连lotus的miner 无法获取信息
![-w324](media/16184575857724.jpg)

![-w257](media/16184577528551.jpg)


### amd 编译
针对AMD CPU
RUSTFLAGS="-C target-cpu=native -g" FFI_BUILD_FROM_SOURCE=1 make clean all

### worker 启动前， 必备的环境变零
    export MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.9VqfYQ830pI0W0oPFWIwvlfb93-5y0VWqTAYWWQdOjg:/ip4/192.168.0.4/tcp/2345/http
    export TMPDIR=/home/fil/tmp-dir
  export WORKER_PATH="/home/fil/seal_dir"
   
   没有 /home/fil/tmp-dir ， worker也不能做任务， 会卡在这个地方：
   ![-w886](media/16182178749735.jpg)

### 下载证明参数文件
lotus-miner fetch-params 32GiB
   
### worker启动 时， 遇到no route to host 解决：
./lotus-worker run --listen="192.168.0.3:3456"
```
2021-04-12T04:32:49.664-0400	ERROR	main	lotus-seal-worker/main.go:514	Registering worker failed: getting worker info: RPC client error: sendRequest failed: Post "http://192.168.0.3:3456/rpc/v0": dial tcp 192.168.0.3:3456: connect: no route to host
2021-04-12T04:32:49.664-0400	WARN	main	lotus-seal-worker/main.go:419	Shutting down...
2021-04-12T04:32:49.666-0400	WARN	main	lotus-seal-worker/main.go:98	http: Server closed
```
worker 地址192.168.0.3:3456 ， worker 要用这个端口接受 miner 发来的任务
这个端口防火墙没打开， 需要打开：
```
[fil@worker ~]$ sudo firewall-cmd --zone=public --add-port=3456/tcp --permanent
[sudo] password for fil:
success
[fil@worker ~]$ sudo firewall-cmd --reload
success
```
worker就可以正常启动了

### control 地址
添加Control地址

lotus-miner actor control set --really-do-it=true f0100933 f0100939

 > Add f3rht...
 > Add f3sxs...
 > Message CID: bafy2bzacecfryzmwe5ghsazmfzporuybm32yw5q6q75neyopifps3c3gll6aq

lotus actor control list

 > name       ID      key        use    balance
 > owner      t01...  f3abcd...  other  15 FIL
 > worker     t01...  f3abcd...  other  10 FIL
 > control-0  t02...  f3defg...  post   100 FIL
 > control-1  t02...  f3defg...  post   100 FIL


配置Control地址
修改Miner的配置文件$LOTUS_MINER_PATH/config.toml，更新[Addresses]中的PreCommitControl和CommitControl地址。

[Addresses]
PreCommitControl = ["f3rht..."]
CommitControl = ["f3sxs..."]

### work获取任务
miner給worker分配一个任务：
[fil@miner ~]$ ./lotus-miner sectors pledge
Created CC sector:  0


worker接受任务， 打印log；
![-w886](media/16182166887498.jpg)

worker 启动时， 没有指定接受的任务类型， 所以这里只接了任务，没有做事情：

![-w507](media/16182170413950.jpg)


worker 的配置：
[fil@worker seal_dir]$ cat storage.json
{
  "StoragePaths": [
    {
      "Path": "/home/fil/seal_dir"
    }
  ]
}

sector配置：
[fil@worker seal_dir]$ cat sectorstore.json
{
  "ID": "af5487c5-c8ad-4d24-b71c-0cc1b737d99c",
  "Weight": 10,
  "CanSeal": true,
  "CanStore": false,
  "MaxStorage": 0
}
### ssh 用-p 制定端口， scp 用 -P 指定端口
scp -P 6000 NVIDIA-Linux-x86_64-460.67.run root@47.102.146.8:/home/fil/
NVIDIA-Linux-x86_64-460.67.run                                                      11%   20MB 618.3KB/s   04:07 ETA


### 环境变量
![-w945](media/16184112740621.jpg)


![-w945](media/16184113468919.jpg)


![-w1000](media/16184756747964.jpg)


### worker 启动


./lotus-worker run --listen="192.168.0.3:3456" --addpiece=true --precommit1=true --unseal=true --precommit2=true --commit=true 

### lotus-miner run错误
![-w977](media/16182105046446.jpg)

```
* [/ip4/127.0.0.1/tcp/40654] dial tcp4 127.0.0.1:40654: connect: connection refused
  * [/ip6/::1/tcp/38686] dial tcp6 [::1]:38686: connect: connection refused
  * [/ip4/192.168.0.220/tcp/40654] dial tcp4 192.168.0.220:40654: connect: no route to host
```
1234端口为监听端口
lotus tcp连接 进入established后的随机分配的端口，这个是连接端口
![-w977](media/16182107140000.jpg)

这个端口也要打开，在lotus节点操作： 
```
[fil@220 ~]$ sudo firewall-cmd --zone=public --add-port=40654/tcp --permanent
[sudo] password for fil:
success
[fil@220 ~]$ sudo firewall-cmd --reload
success
```
重新运行 lotus-miner run, 就正常了, lotus-miner info也可以正常显示了
![-w489](media/16182111584854.jpg)


因为还没有挖矿， 所以miner balance里都是0


### ipfs_gateway
export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/ 


### mkfs.ext4  /dev/sda 时 出现/dev/sda is apparently in use by the system 的解决办法

[root@145 ~]# dmsetup status
centos00-home: 0 1829756928 linear
centos00-swap: 0 16384000 linear
centos00-root: 0 104857600 linear
centos-home: 0 3783393280 linear
centos-swap: 0 16252928 linear
centos-root: 0 104857600 linear
[root@145 ~]# dmsetup remove_all
[root@145 ~]# dmsetup status
centos00-home: 0 1829756928 linear
centos00-swap: 0 16384000 linear
centos00-root: 0 104857600 linear


### centos 安装 nfs
服务端：
```
[root@nfs_server ~]# yum -y install nfs-utils rpcbind
[root@nfs_server ~]# systemctl enable rpcbind
[root@nfs_server ~]# systemctl enable nfs-server
Created symlink from /etc/systemd/system/multi-user.target.wants/nfs-server.service to /usr/lib/systemd/system/nfs-server.service.
[root@nfs_server ~]# systemctl enable nfs-lock
[root@nfs_server ~]# systemctl enable nfs-idmap
3 启动nfs service

[root@nfs_server ~]# systemctl start rpcbind
[root@nfs_server ~]# systemctl start nfs-server
[root@nfs_server ~]# systemctl start nfs-lock
[root@nfs_server ~]# systemctl start nfs-idmap


[root@nfs_server ~]# echo "/var/tmp/filecoin-proof-parameters 192.168.0.*(rw,sync,no_root_squash)" >> /etc/exports

echo "/home/fil/.lotusminer/cache 192.168.0.*(rw,sync,no_root_squash)" >> /etc/exports
[root@nfs_server ~]# exportfs -a          使exports的修改生效
```

可使用 命令 iptables -L -n  查看开放的端口

客户端
```
[root@nfs_client ~]# yum -y install nfs-utils
# showmount -e 192.168.0.220

[root@nfs_client ~]# mkdir -p /application/share
[root@nfs_client ~]# mount -t nfs 192.168.0.220:/var/tmp/filecoin-proof-parameters /var/tmp/filecoin-proof-parameters

mount -t nfs 192.168.0.220:/home/fil/.lotusminer/cache /home/fil/.lotusminer/cache


mount -t nfs 192.168.0.4:/var/tmp/seal /home/fil/seal_dir


```

![-w583](media/16177855055046.jpg)


Device or resource busy 原因是 目录是nfs的挂在点
![-w630](media/16177864032685.jpg)

df -h 看到
![-w1014](media/16177864740380.jpg)


客户端df 看到结果：

![-w786](media/16177023388031.jpg)


问题：[root@145 ~]# showmount -e 192.168.0.2
clnt_create: RPC: Port mapper failure - Unable to receive: errno 113 (No route to host)
解决
服务端执行：
[root@localhost ~]# iptables -F



问题： 
/etc/exports 修改
exprot -a 后，
客户端还是挂在之前的服务端目录：
[root@145 ~]# mount -t nfs 192.168.0.2:/home/fil/nfs /home/fil/nfs
mount.nfs: mounting 192.168.0.2:/home/fil/nfs failed, reason given by server: No such file or directory


解决： 服务端需要  systemctl restart nfs-server 才有效


###  showmount -e 报错
[root@miner ~]# showmount -e 192.168.0.145
rpc mount export: RPC: Unable to receive; errno = No route to host

解决办法：




firewall-cmd 要打开的端口：

先试一下这些端口：

113/tcp 2049/tcp 111/tcp 111/udp 4046/udp 113/udp 

不行，再开这些：
[root@145 ~]# firewall-cmd --list-ports
 113/tcp 2049/tcp 111/tcp 111/udp 4046/udp 113/udp 4002/udp 4004/udp 4004/tcp 4002/tcp
 
 端口打开后， 要重启nfs
 service nfs restart
![-w353](media/16184743999310.jpg)








### 解决openCl 链接不到的问题

[root@iZuf664ztcz8m5wzm0b0tyZ /]# find -name "*OpenC*"
./opt/intel/opencl/libOpenCL.so
./opt/intel/opencl/libOpenCL.so.1
./opt/intel/opencl/OpenCL.pc
[root@iZuf664ztcz8m5wzm0b0tyZ /]# ln -s /opt/intel/opencl/libOpenCL.so /usr/lib/libOpenCL.so


### sync wait 期间， ./lotus 大小递减
![-w400](media/16128378666146.jpg)


![-w358](media/16128381018408.jpg)

###  miner 消耗
controlller 发给 miner 是precommit 消息
  owner  发给 miner   prove commit 消息
  
miner 都是to 地址， 都是消耗

通过to地址， 统计


预存款惩罚：
在封装算力的时候， 如果消息失败， 预存款里的钱会被惩罚。 即是在precommit看， 


post惩罚： 
proving， 24小时内如果没有证明， 而且每天惩罚， 超过7天， 就没有机会恢复了， 钱会被罚没


抵押： 
扇区生命周期， 180天懂啊540天。 到了， 可以选择续期， 接着， 再一个生命周期， 到期， 也不续期了， 


算力

扇区的生命周期肯定会大于存储订单的生命周期

### 下载证明参数文件，速度很快
![-w1706](media/16128385027265.jpg)


### IPFS_GATEWAY
Speed up proof parameter download for first boot
Running Lotus requires the download of chain's proof parameters which are large files which by default are hosted outside of China and very slow to download there. To get around that, users should set the following environment variable when running either of lotus, lotus-miner and lotus-worker:

export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/

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


### worker 做完一个sector的完整log
```
2021-04-13T01:58:02.948-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:0; a:1): {{0 0} /home/fil/seal_dir/unsealed/s-t01002-17  }
2021-04-13T01:58:02.948-0400    ^[[33mWARN^[[0m ffiwrapper      ffiwrapper/partialfile.go:70    could not allocated space, ignoring: operation not supported
2021-04-13T01:58:02.986-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:1; a:0): {{0 0} /home/fil/seal_dir/unsealed/s-t01002-17  }
2021-04-13T01:58:02.995-0400    ^[[31mERROR^[[0m        stores  stores/local.go:117     getting disk usage of '/home/fil/seal_dir/sealed/s-t01002-17': file does not exist
2021-04-13T01:58:02.995-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:1; a:6): {{0 0} /home/fil/seal_dir/unsealed/s-t01002-17 /home/fil/seal_dir/sealed/s-t01002-17 /home/fil/seal_dir/cache/s-t01002-17}
2021-04-13T01:58:03.127-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:6; a:0): {{0 0}  /home/fil/seal_dir/sealed/s-t01002-17 /home/fil/seal_dir/cache/s-t01002-17}
2021-04-13T01:58:03.132-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:6; a:0): {{0 0}  /home/fil/seal_dir/sealed/s-t01002-17 /home/fil/seal_dir/cache/s-t01002-17}
2021-04-13T01:59:12.133-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:6; a:0): {{0 0}  /home/fil/seal_dir/sealed/s-t01002-17 /home/fil/seal_dir/cache/s-t01002-17}
2021-04-13T01:59:12.138-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:6; a:0): {{0 0}  /home/fil/seal_dir/sealed/s-t01002-17 /home/fil/seal_dir/cache/s-t01002-17}
2021-04-13T01:59:56.129-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:7; a:0): {{0 0} /home/fil/seal_dir/unsealed/s-t01002-17 /home/fil/seal_dir/sealed/s-t01002-17 /home/fil/seal_dir/cache/s-t01002-17}
2021-04-13T01:59:56.134-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:4; a:0): {{0 0}   /home/fil/seal_dir/cache/s-t01002-17}
2021-04-13T01:59:56.144-0400    ^[[34mINFO^[[0m stores  stores/local.go:614     remove /home/fil/seal_dir/unsealed/s-t01002-17
```

### 存储raid 
34个盘 做raid 5 0

### miner set 
```
[fil@machine1 ~]$ ./lotus-miner actor set-addrs /ip4/8.130.54.141/tcp/24001
Requested multiaddrs change in message bafy2bzacecsrlg7uyvowv65fr57522ly2w7sq7reanoypetjug2jyk6jmojz2
```

### nas
![-w1381](media/16133626969534.jpg)


![-w1386](media/16133627219853.jpg)


### centos7 安装翻墙

/etc/hosts ：
```

185.199.108.154               github.githubassets.com
140.82.114.21                 central.github.com
185.199.108.133               desktop.githubusercontent.com
185.199.108.153               assets-cdn.github.com
185.199.108.133               camo.githubusercontent.com
185.199.108.133               github.map.fastly.net
199.232.69.194                github.global.ssl.fastly.net
140.82.113.4                  gist.github.com
185.199.108.153               github.io
140.82.114.3                  github.com
140.82.113.5                  api.github.com
185.199.108.133               raw.githubusercontent.com
185.199.108.133               user-images.githubusercontent.com
185.199.108.133               favicons.githubusercontent.com
185.199.108.133               avatars5.githubusercontent.com
185.199.108.133               avatars4.githubusercontent.com
185.199.108.133               avatars3.githubusercontent.com
185.199.108.133               avatars2.githubusercontent.com
185.199.108.133               avatars1.githubusercontent.com
185.199.108.133               avatars0.githubusercontent.com
185.199.108.133               avatars.githubusercontent.com
140.82.113.10                 codeload.github.com
52.216.226.40                 github-cloud.s3.amazonaws.com
52.216.162.99                 github-com.s3.amazonaws.com
52.216.142.196                github-production-release-asset-2e65be.s3.amazonaws.com
52.217.97.236                 github-production-user-asset-6210df.s3.amazonaws.com
52.217.194.41                 github-production-repository-file-5c1aeb.s3.amazonaws.com
185.199.108.153               githubstatus.com
64.71.168.201                 github.community
185.199.108.133               media.githubusercontent.com
```

安装 shadow-install.sh
![-w794](media/16175078539956.jpg)

```
Congratulations, ShadowsocksR server install completed!
Your Server IP        :  153.34.162.49
Your Server Port      :  7890
Your Password         :  fsjsjsjx
Your Protocol         :  origin
Your obfs             :  plain
Your Encryption Method:  aes-256-cfb

Your QR Code: (For ShadowsocksR Windows, Android clients only)
 ssr://MTUzLjM0LjE2Mi40OTo3ODkwOm9yaWdpbjphZXMtMjU2LWNmYjpwbGFpbjpabk5xYzJwemFuZy8/b2Jmc3BhcmFtPQ==
Your QR Code has been saved as a PNG file path:
 /root/shadowsocks_r_qr.png

Welcome to visit: https://teddysun.com/486.html
Enjoy it!
```
![-w977](media/16175409605615.jpg)

下载文件， 进不去，自己设置个目录。 


### 固定ip
查网关：

```
[root@bogon network-scripts]# ip route show
default via 192.168.0.1 dev enp3s0 proto dhcp metric 100
192.168.0.0/24 dev enp3s0 proto kernel scope link src 192.168.0.222 metric 100
[root@bogon network-scripts]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.0.1     0.0.0.0         UG    100    0        0 enp3s0
192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp3s0
```

![-w864](media/16177835538213.jpg)

/etc/sysconfig/network-scripts/network-scripts : 
![-w622](media/16175793578199.jpg)
改为：

```
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp3s0
UUID=cf2f3621-649c-4cf8-9f0b-3f643d9f876c
DEVICE=enp3s0
ONBOOT=yes
IPADDR=192.168.0.221
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
```

service network restart


BOOTPROTO=static 导致
yum install htop 安装不了， 
改回BOOTPROTO=dhcp 就好了
### 修改主机名
[root@localhost ~]# hostnamectl set-hostname worker
重新登陆看到
[root@worker ~]#    
### CentOS7操作系统安装及安装后解决ping不通网络和主机域名的问题
 vi /etc/sysconfig/network-scripts/ifcfg-ens33 进入网络配置文件
 ONBOOT=no
 改为
 ONBOOT=yes
### make

github 时好时不好  
```
[fil@bogon lotus]$ make
git submodule update --init --recursive
Cloning into 'gen/extern/fil-blst'...
remote: Enumerating objects: 349, done.
remote: Counting objects: 100% (349/349), done.
remote: Compressing objects: 100% (224/224), done.
Receiving objects:  58% (203/349), 172.00 KiB | 7.00 KiB/s
```

### frpc 设置开启自启动

将frpc和frpc.ini文件拷贝到对应目录，设置执行权限
$ sudo cp frpc /usr/bin/frpc
$ sudo chmod -R 777 /usr/bin/frpc
$ sudo mkdir /etc/frp
$ sudo cp frpc.ini /etc/frp/frpc.ini
$ sudo cp systemd/frpc.service /lib/systemd/system/frpc.service


刷新服务列表：
systemctl daemon-reload

设置开机自启
systemctl enable frpc


启动服务
systemctl start frpc



### timedatectl # 查看系统时间方面的各种状态

查看当前时区
$timedatectl status
Local time: 四 2014-12-25 10:52:10 CST
Universal time: 四 2014-12-25 02:52:10 UTC
RTC time: 四 2014-12-25 02:52:10
Timezone: Asia/Shanghai (CST, +0800)
NTP enabled: yes
NTP synchronized: yes
RTC in local TZ: no
DST active: n/a

设置时区
timedatectl set-timezone Asia/Shanghai # 设置系统时区为上海


### 追高度现象
![-w460](media/16183921160899.jpg)

sync wait 高度， target 一直比base 多1个， 这一版在私链上， 靠这个高度出块。 创世节点的高度， 低于时间高度， 只有当前矿工高度最高， 所以不断追加1。 链高度最高的是当前矿工， 这个矿工的proving，就可以回到原来的水平， 恢复算力： 


![-w481](media/16183924101934.jpg)

又16KiB 恢复到 20KiB： 
blacklist nouveau
options nouveau modeset=0
![-w506](media/16183923794292.jpg)



### 没有gpu而导出FIL_PROOFS_USE_GPU_COLUMN_BUILDER 1
没有gpu而导出FIL_PROOFS_USE_GPU_COLUMN_BUILDER 1， 第二部lotus-seed就出错
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 # When having GPU.
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1   # When having GPU.



### sector 
![-w670](media/16177781847274.jpg)


### 做一个sector， 打印的log


![-w1051](media/16177784397053.jpg)


![-w670](media/16177783941384.jpg)

miner打印的log
```
2021-04-07T02:51:41.000-0400	WARN	advmgr	sector-storage/manager.go:323	stub NewSector
2021-04-07T02:51:41.000-0400	INFO	sectors	storage-sealing/garbage.go:36	Creating CC sector 5
2021-04-07T02:51:41.005-0400	INFO	sectors	storage-sealing/states_sealing.go:45	performing filling up rest of the sector...	{"sector": "5"}
2021-04-07T02:51:41.005-0400	WARN	sectors	storage-sealing/states_sealing.go:69	Creating 1 filler pieces for sector 5
2021-04-07T02:51:41.005-0400	INFO	sectors	storage-sealing/states_sealing.go:85	Pledge {{1002 5} 5}, contains []
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 1 queued; 2 open windows
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched.go:449	SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched.go:450	SCHED Acceptable win: [[0 1]]
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched.go:465	SCHED try assign sqi:0 sector 5 to window 0
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched.go:472	SCHED ASSIGNED sqi:0 sector 5 task seal/v0/addpiece to window 0
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched_worker.go:368	assign worker sector 5
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 2 open windows
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched_worker.go:278	task done{"workerid": "3d3202fe-f091-4f2f-b760-c87f1248825a"}
2021-04-07T02:51:41.005-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 2 open windows
2021-04-07T02:51:41.007-0400	DEBUG	advmgr	sector-storage/worker_local.go:129	acquired sector {{1002 5} 5} (e:0; a:1): {{0 0} /home/fil/.lotusminer/unsealed/s-t01002-5  }
2021-04-07T02:51:41.026-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 1 queued; 2 open windows
2021-04-07T02:51:41.026-0400	DEBUG	advmgr	sector-storage/sched.go:449	SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-04-07T02:51:41.026-0400	DEBUG	advmgr	sector-storage/sched.go:450	SCHED Acceptable win: [[0 1]]
2021-04-07T02:51:41.027-0400	DEBUG	advmgr	sector-storage/sched.go:465	SCHED try assign sqi:0 sector 5 to window 0
2021-04-07T02:51:41.027-0400	DEBUG	advmgr	sector-storage/sched.go:472	SCHED ASSIGNED sqi:0 sector 5 task seal/v0/precommit/1 to window 0
2021-04-07T02:51:41.027-0400	DEBUG	advmgr	sector-storage/sched_worker.go:368	assign worker sector 5
2021-04-07T02:51:41.027-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 2 open windows
2021-04-07T02:51:41.029-0400	DEBUG	advmgr	sector-storage/worker_local.go:129	acquired sector {{1002 5} 5} (e:1; a:0): {{0 0} /home/fil/.lotusminer/unsealed/s-t01002-5  }
2021-04-07T02:51:41.029-0400	DEBUG	advmgr	sector-storage/sched_worker.go:278	task done{"workerid": "3d3202fe-f091-4f2f-b760-c87f1248825a"}
2021-04-07T02:51:41.029-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 2 open windows
2021-04-07T02:51:41.032-0400	ERROR	stores	stores/local.go:117	getting disk usage of '/home/fil/.lotusminer/sealed/s-t01002-5': file does not exist
2021-04-07T02:51:41.032-0400	DEBUG	advmgr	sector-storage/worker_local.go:129	acquired sector {{1002 5} 5} (e:1; a:6): {{0 0} /home/fil/.lotusminer/unsealed/s-t01002-5 /home/fil/.lotusminer/sealed/s-t01002-5 /home/fil/.lotusminer/cache/s-t01002-5}
2021-04-07T02:51:41.046-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 1 queued; 2 open windows
2021-04-07T02:51:41.046-0400	DEBUG	advmgr	sector-storage/sched.go:449	SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-04-07T02:51:41.046-0400	DEBUG	advmgr	sector-storage/sched.go:450	SCHED Acceptable win: [[0 1]]
2021-04-07T02:51:41.046-0400	DEBUG	advmgr	sector-storage/sched.go:465	SCHED try assign sqi:0 sector 5 to window 0
2021-04-07T02:51:41.046-0400	DEBUG	advmgr	sector-storage/sched.go:472	SCHED ASSIGNED sqi:0 sector 5 task seal/v0/precommit/2 to window 0
2021-04-07T02:51:41.046-0400	DEBUG	advmgr	sector-storage/sched_worker.go:368	assign worker sector 5
2021-04-07T02:51:41.046-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 2 open windows
2021-04-07T02:51:41.048-0400	DEBUG	advmgr	sector-storage/worker_local.go:129	acquired sector {{1002 5} 5} (e:6; a:0): {{0 0}  /home/fil/.lotusminer/sealed/s-t01002-5 /home/fil/.lotusminer/cache/s-t01002-5}
2021-04-07T02:51:41.048-0400	DEBUG	advmgr	sector-storage/sched_worker.go:278	task done{"workerid": "3d3202fe-f091-4f2f-b760-c87f1248825a"}
2021-04-07T02:51:41.048-0400	DEBUG	advmgr	sector-storage/sched.go:354	SCHED 0 queued; 2 open windows
2021-04-07T02:51:41.050-0400	DEBUG	advmgr	sector-storage/worker_local.go:129	acquired sector {{1002 5} 5} (e:6; a:0): {{0 0}  /home/fil/.lotusminer/sealed/s-t01002-5 /home/fil/.lotusminer/cache/s-t01002-5}
2021-04-07T02:51:41.088-0400	INFO	sectors	storage-sealing/states_sealing.go:316	submitting precommit for sector 5 (deposit: 163362441809):
2021-04-07T02:51:41.116-0400	INFO	sectors	storage-sealing/states_sealing.go:334	Sector precommitted: 5
```

![-w629](media/16177802171388.jpg)

复制证明运算中的 layer文件， tree文件展开：
![-w681](media/16177804623258.jpg)


已经上链的证明的：
![-w681](media/16177805743766.jpg)


![-w468](media/16177822745135.jpg)

### 指定sectorid信息
```
[fil@220 ~]$ ./lotus-miner sectors status --log 1
SectorID:	1
Status:		Proving
CIDcommD:	baga6ea4seaqpy7usqklokfx2vxuynmupslkeutzexe2uqurdg5vhtebhxqmpqmy
CIDcommR:	bagboea4b5abcbnym7z3pgc64fk5wwsk3nsmz62jamgaa3pekzelmm3fv5q6g6zji
Ticket:		c3a1ca12b981a8a59f9a4764edf3398edd239b2afa8ca2bbd57e0091ec193aa0
TicketH:	1822
Seed:		62a9ec8794bdb9cf9899e3e1fde9dd3c84ecb285bfeeace7fdbf4924b25eba85
SeedH:		2733
Precommit:	bafy2bzacechsyl7ovbmimehbcdxy3unfxk6rfhxyfhrufkjtc76scyjiov4i6
Commit:		bafy2bzaceabsx5zvqy7ofnwlupxfd3rahzjovkg7evkhorhat52zhit54mtu4
Proof:		9562e84a611cc12f3ebdedb05bb50cf373d37408756c7d5e4054f5f88e01c08defcaa9b630625077ee7653299f4558fb860a3636b7b5d48c39540269f81012f6140a8d589c1d4d51093f5bc2b379fd6902e241aef902d0d398e69bffbb8ca8c60e5c38990794723a52c6c5a68b747dfbf4b820fb3872d974e94fa2a6571f15c57cfb8db8901355e8475d394829d9c559b3035c845ef08a51038d695bd30e5557b6d96eb97d23299e6df65f0fdb8fa382e740879568ec16910eb29133b6269593
Deals:		[0]
Retries:	0
--------
Event Log:
0.	2021-04-07 02:37:15 -0400 EDT:	[event;sealing.SectorStartCC]	{"User":{"ID":1,"SectorType":5}}
1.	2021-04-07 02:37:15 -0400 EDT:	[event;sealing.SectorPacked]	{"User":{"FillerPieces":[{"Size":2048,"PieceCID":{"/":"baga6ea4seaqpy7usqklokfx2vxuynmupslkeutzexe2uqurdg5vhtebhxqmpqmy"}}]}}
2.	2021-04-07 02:37:15 -0400 EDT:	[event;sealing.SectorTicket]	{"User":{"TicketValue":"w6HKErmBqKWfmkdk7fM5jt0jmyr6jKK71X4AkewZOqA=","TicketEpoch":1822}}
3.	2021-04-07 02:37:15 -0400 EDT:	[event;sealing.SectorPreCommit1]	{"User":{"PreCommit1Out":"eyJyZWdpc3RlcmVkX3Byb29mIjoiU3RhY2tlZERyZzJLaUJWMV8xIiwibGFiZWxzIjp7IlN0YWNrZWREcmcyS2lCVjEiOnsibGFiZWxzIjpbeyJwYXRoIjoiL2hvbWUvZmlsLy5sb3R1c21pbmVyL2NhY2hlL3MtdDAxMDAyLTEiLCJpZCI6ImxheWVyLTEiLCJzaXplIjo2NCwicm93c190b19kaXNjYXJkIjo1fSx7InBhdGgiOiIvaG9tZS9maWwvLmxvdHVzbWluZXIvY2FjaGUvcy10MDEwMDItMSIsImlkIjoibGF5ZXItMiIsInNpemUiOjY0LCJyb3dzX3RvX2Rpc2NhcmQiOjV9XSwiX2giOm51bGx9fSwiY29uZmlnIjp7InBhdGgiOiIvaG9tZS9maWwvLmxvdHVzbWluZXIvY2FjaGUvcy10MDEwMDItMSIsImlkIjoidHJlZS1kIiwic2l6ZSI6MTI3LCJyb3dzX3RvX2Rpc2NhcmQiOjV9LCJjb21tX2QiOlsyNTIsMTI2LDE0NiwxMzAsMTUwLDIyOSwyMiwyNTAsMTczLDIzMywxMzQsMTc4LDE0MywxNDYsMjEyLDc0LDc5LDM2LDE4NSw1Myw3Miw4MiwzNSw1NSwxMDYsMTIxLDE0NCwzOSwxODgsMjQsMjQ4LDUxXX0="}}
4.	2021-04-07 02:37:15 -0400 EDT:	[event;sealing.SectorPreCommit2]	{"User":{"Sealed":{"/":"bagboea4b5abcbnym7z3pgc64fk5wwsk3nsmz62jamgaa3pekzelmm3fv5q6g6zji"},"Unsealed":{"/":"baga6ea4seaqpy7usqklokfx2vxuynmupslkeutzexe2uqurdg5vhtebhxqmpqmy"}}}
5.	2021-04-07 02:37:15 -0400 EDT:	[event;sealing.SectorPreCommitted]	{"User":{"Message":{"/":"bafy2bzacechsyl7ovbmimehbcdxy3unfxk6rfhxyfhrufkjtc76scyjiov4i6"},"PreCommitDeposit":"151778864101","PreCommitInfo":{"SealProof":5,"SectorNumber":1,"SealedCID":{"/":"bagboea4b5abcbnym7z3pgc64fk5wwsk3nsmz62jamgaa3pekzelmm3fv5q6g6zji"},"SealRandEpoch":1822,"DealIDs":[],"Expiration":1552369,"ReplaceCapacity":false,"ReplaceSectorDeadline":0,"ReplaceSectorPartition":0,"ReplaceSectorNumber":0}}}
6.	2021-04-07 02:37:41 -0400 EDT:	[event;sealing.SectorPreCommitLanded]	{"User":{"TipSet":"AXGg5AIga39fuwQQyPIQj+Cq3qCO9lVLgNytFW6FOs3z6dBr4Jc="}}
7.	2021-04-07 02:38:21 -0400 EDT:	[event;sealing.SectorSeedReady]	{"User":{"SeedValue":"Yqnsh5S9uc+YmePh/endPITssoW/7qzn/b9JJLJeuoU=","SeedEpoch":2733}}
8.	2021-04-07 02:40:20 -0400 EDT:	[event;sealing.SectorCommitted]	{"User":{"Proof":"lWLoSmEcwS8+ve2wW7UM83PTdAh1bH1eQFT1+I4BwI3vyqm2MGJQd+52UymfRVj7hgo2Nre11Iw5VAJp+BAS9hQKjVicHU1RCT9bwrN5/WkC4kGu+QLQ05jmm/+7jKjGDlw4mQeUcjpSxsWmi3R9+/S4IPs4ctl06U+iplcfFcV8+424kBNV6EddOUgp2cVZswNchF7wilEDjWlb0w5VV7bZbrl9IymebfZfD9uPo4LnQIeVaOwWkQ6ykTO2JpWT"}}
9.	2021-04-07 02:40:20 -0400 EDT:	[event;sealing.SectorCommitSubmitted]	{"User":{"Message":{"/":"bafy2bzaceabsx5zvqy7ofnwlupxfd3rahzjovkg7evkhorhat52zhit54mtu4"}}}
10.	2021-04-07 02:40:53 -0400 EDT:	[event;sealing.SectorProving]	{"User":{}}
11.	2021-04-07 02:40:53 -0400 EDT:	[event;sealing.SectorFinalized]	{"User":{}}
```
#### 服务端
![-w754](media/16175867667318.jpg)

![-w1026](media/16175866000277.jpg)
#### 客户端 
![-w720](media/16175866475598.jpg)


![-w1026](media/16175865284184.jpg)


### 10M 速度
下载ssnpshot晚上7点打到10M下载速度
![-w1038](media/16175393930343.jpg)

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


###  worker链接到miner, 会自动加上 	URL: http://192.168.0.145:3457/remote

![-w622](media/16184019961764.jpg)


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

### sector的active

![-w583](media/16182932569390.jpg)


### worker机器 产生的中间文件 和向 miner机器要拷贝的文件
worker机器 产生的中间文件：
![-w610](media/16182940892905.jpg)
worker拷贝到 miner机器上的文件， 这些文件miner做证明用：
![-w640](media/16182942535866.jpg)
可见， cache目录里的p_aux, t_aux,  tree-r 文件， 和sealed目录下的文件都要拷贝被miner, 这些文件要作为永久文件保存下来， 要备份到存储服务器。 

worker 把文件拷贝好后， 就要删除这些cache目录， sealed目录下的文件： 
![-w458](media/16182945056733.jpg)

拷贝时间要算在算力封装时间里的。 




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


### miner 调度worker做sector的log
```
2021-04-13T01:59:53.008-0400    ^[[34mINFO^[[0m miner   miner/miner.go:442      Time delta between now and our mining base: 1s (nulls: 0)
2021-04-13T01:59:56.117-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:354     SCHED 1 queued; 4 open windows
2021-04-13T01:59:56.124-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:449     SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-04-13T01:59:56.124-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:450     SCHED Acceptable win: [[2 3 0 1]]
2021-04-13T01:59:56.124-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:465     SCHED try assign sqi:0 sector 17 to window 2
2021-04-13T01:59:56.124-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:472     SCHED ASSIGNED sqi:0 sector 17 task seal/v0/finalize to window 2
2021-04-13T01:59:56.124-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched_worker.go:368      assign worker sector 17
2021-04-13T01:59:56.124-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:354     SCHED 0 queued; 4 open windows
2021-04-13T01:59:56.129-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched_worker.go:278      task done       {"workerid": "00b557fa-52f7-4bfe-b463-ac89c0ceaaef"}
2021-04-13T01:59:56.129-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:354     SCHED 0 queued; 4 open windows
2021-04-13T01:59:56.146-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:354     SCHED 1 queued; 4 open windows
2021-04-13T01:59:56.151-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:449     SCHED windows: [{allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]} {allocated:{memUsedMin:0 memUsedMax:0 gpuUsed:false cpuUse:0 cond:<nil>} todo:[]}]
2021-04-13T01:59:56.151-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:450     SCHED Acceptable win: [[0 1]]
2021-04-13T01:59:56.151-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:465     SCHED try assign sqi:0 sector 17 to window 0
2021-04-13T01:59:56.151-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:472     SCHED ASSIGNED sqi:0 sector 17 task seal/v0/fetch to window 0
2021-04-13T01:59:56.151-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched_worker.go:368      assign worker sector 17
2021-04-13T01:59:56.151-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:354     SCHED 0 queued; 4 open windows
2021-04-13T01:59:56.153-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/worker_local.go:129      acquired sector {{1002 17} 5} (e:6; a:0): {{0 0}  /var/tmp/seal/sealed/s-t01002-17 /var/tmp/seal/cache/s-t01002-17}
2021-04-13T01:59:56.153-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched_worker.go:278      task done       {"workerid": "8ae2b92c-94f5-4865-a4f4-c6f3c7885504"}
2021-04-13T01:59:56.153-0400    ^[[35mDEBUG^[[0m        advmgr  sector-storage/sched.go:354     SCHED 0 queued; 4 open windows
2021-04-13T01:59:56.157-0400    ^[[35mDEBUG^[[0m        stores  stores/local.go:661     moving {{1002 17} 5}(2) to storage: c5c01420-894d-458c-97ac-8a7767bd6a7d(se:true; st:false) -> bd9f34c9-fd98-4157-bbbd-43b20b59d394(se:true; st:true)
2021-04-13T01:59:56.157-0400    ^[[35mDEBUG^[[0m        stores  stores/util_unix.go:28  move sector data        {"from": "/var/tmp/seal/sealed/s-t01002-17", "to": "/home/fil/.lotusminer/sealed/s-t01002-17"}
2021-04-13T01:59:56.161-0400    ^[[35mDEBUG^[[0m        stores  stores/local.go:661     moving {{1002 17} 5}(4) to storage: c5c01420-894d-458c-97ac-8a7767bd6a7d(se:true; st:false) -> bd9f34c9-fd98-4157-bbbd-43b20b59d394(se:true; st:true)
2021-04-13T01:59:56.161-0400    ^[[35mDEBUG^[[0m        stores  stores/util_unix.go:28  move sector data        {"from": "/var/tmp/seal/cache/s-t01002-17", "to": "/home/fil/.lotusminer/cache/s-t01002-17"}
2021-04-13T01:59:56.168-0400    ^[[34mINFO^[[0m sectors storage-sealing/states_sealing.go:568   Proving sector 17
```


### sealing 
worker 做完一个sector, 会做拷贝， 拷贝的log：
```
stores  stores/local.go:661     moving {{1002 17} 5}(2) to storage: c5c01420-894d-458c-97ac-8a7767bd6a7d(se:true; st:false) -> bd9f34c9-fd98-4157-bbbd-43b20b59d394(se:true; st:true)
2021-04-13T01:59:56.157-0400    ^[[35mDEBUG^[[0m        stores  stores/util_unix.go:28  move sector data        {"from": "/var/tmp/seal/sealed/s-t01002-17", "to": "/home/fil/.lotusminer/sealed/s-t01002-17"}
2021-04-13T01:59:56.161-0400    ^[[35mDEBUG^[[0m        stores  stores/local.go:661     moving {{1002 17} 5}(4) to storage: c5c01420-894d-458c-97ac-8a7767bd6a7d(se:true; st:false) -> bd9f34c9-fd98-4157-bbbd-43b20b59d394(se:true; st:true)
2021-04-13T01:59:56.161-0400    ^[[35mDEBUG^[[0m        stores  stores/util_unix.go:28  move sector data        {"from": "/var/tmp/seal/cache/s-t01002-17", "to": "/home/fil/.lotusminer/cache/s-t01002-17"}
```
miner log中
{"from": "/var/tmp/seal/sealed/s-t01002-17", "to": "/home/fil/.lotusminer/sealed/s-t01002-17"}
就是将worker miner 共享的 seal store 拷贝到 

miner 要设置几个存储位置： 
#### use: seal store 
 lotus-miner 在证明时， 会到这个目录下取文件， 一个是cache, 一个是sealed, 这个默认配置为：
![-w682](media/16183011190018.jpg)


#### use : seal
 worker 的 封装过程的存放中间文件的存储位置， 这个存储要worker 能写进去， miner 能读出来， worker写好， miner把这个存储下的cache， sealed下的证明需要的文件， 拷贝到use: seal store 目录下，
 这个存储要配置为nfs, worker机器的WORKER_PATH要挂在到这个nfs: 
 export WORKER_PATH="/home/fil/seal_dir"
 ![-w618](media/16183007035254.jpg)
192.168.0.4:/var/tmp/seal 就是miner 上的nfs存储目录。 miner与worker共享这个目录。seal需要在miner机器 指定好：
```
lotus-miner storage attach --init --seal  /var/tmp/seal
```
lotus-miner storage list看到这样配置：
![-w678](media/16183010847965.jpg)



10T配置


miner证明： 
use: seal store :  10T 固态硬盘， 速度快， nvme 怎么做到10T， 可以raid 吗




防火墙要配置， 端口不能随意开



永久存储：
storage： 15T 机械硬盘


### miner info解释
```
[fil@miner ~]$ ./lotus-miner info
Chain: [sync ok] [basefee 100 aFIL]
Miner: t01002 (2 KiB sectors)
Power: 26 Ki / 266 Ki (9.7744%)
	Raw: 26 KiB / 50 KiB (52.0000%)
	本矿工。24K 算力， 全网 50K 算力
	Committed: 26 KiB
	committed大于 proving， 
	
	Proving: 26 KiB
	算力为proving 的大小， 
Expected block win rate: 10556.3520/day (every 8s)

Deals: 0, 0 B
	Active: 0, 0 B (Verified: 0, 0 B)

Miner Balance:    3876.364 FIL
      PreCommit:  0
      Pledge:     774.86 nFIL
      Vesting:    2907.192 FIL
      Available:  969.171 FIL
Market Balance:   0
       Locked:    0
       Available: 0
Worker Balance:   999.893 FIL
Total Spendable:  1969.064 FIL

Sectors:
	Total: 19  总数包括移除的和proving的
	Proving: 13  13乘以sector大小， 就是本矿工算力
	Removed: 6 因cache, seal找不到，就被移除了， 总共移除6个sector  
```


### miner 挖矿的log

```
2021-04-13T05:21:01.351-0400	INFO	miner	miner/miner.go:442	Time delta between now and our mining base: 1s (nulls: 0)
2021-04-13T05:21:01.359-0400	INFO	storageminer	storage/miner.go:256	Computing WinningPoSt ;[{SealProof:5 SectorNumber:15 SealedCID:bagboea4b5abcakhzjg3kw3kft3dig6ro3hvqjbz63c34jnwlunrzbcv5lpdycpct}]; [67 231 5 160 72 48 198 8 232 230 123 47 204 120 127 153 215 218 162 145 254 180 119 101 61 77 47 96 224 203 45 242]
2021-04-13T05:21:03.183-0400	INFO	storageminer	storage/miner.go:263	GenerateWinningPoSt took 1.823461979s
2021-04-13T05:21:03.202-0400	INFO	miner	miner/miner.go:506	mined new block	{"cid": "bafy2bzacedmv33uli7vowz26ld3pzbq3ujcb4l65bnpoazdkmyjmwedzjdm3k", "height": "28935", "miner": "t01002", "parents": ["t01000","t01002"], "took": 1.855581511}
```


### 速度限制

![-w960](media/16183103783905.jpg)
nvme 速度可以100MB/s 


###  miner 惩罚
```
[fil@miner ~]$ ./lotus-miner info
Chain: [sync behind! (3h27m56s behind)] [basefee 100 aFIL]
Miner: t01002 (2 KiB sectors)
Power: 0  / 240 Ki (0.0000%)
	Raw: 0 B / 24 KiB (0.0000%)
	本来有24KiB 算力， 但没有证明上， 就被惩罚成0
	Committed: 26 KiB
	Proving: 26 KiB (26 KiB Faulty, 24KiB 没有被证明， 100.00%)
Below minimum power threshold, no blocks will be won
Deals: 0, 0 B
	Active: 0, 0 B (Verified: 0, 0 B)

Miner Balance:    20075.194 FIL
      PreCommit:  0
      Pledge:     774.86 nFIL
      Vesting:    13216.076 FIL
      Available:  6859.118 FIL
Market Balance:   0
       Locked:    0
       Available: 0
Worker Balance:   999.893 FIL
Total Spendable:  7859.011 FIL

Sectors:
	Total: 19
	Proving: 13
	Removed: 6
```
	
miner 连接 worker的log： 
	2021-04-14T03:59:57.365-0400    ^[[33mWARN^[[0m advmgr  sector-storage/sched_worker.go:213      failed to check worker session  {"error": "RPC client error: sendRequest failed: Post \"http://192.168.0.3:3456/rpc/v0\": dial tcp 192.168.0.3:3456: connect: network is unreachable"}
	

证明失败的proving
```
[fil@miner ~]$ ./lotus-miner proving deadlines
Miner: t01002
deadline  partitions  sectors (faults)  proven partitions
0         1           2 (2)             0
1         1           2 (2)             0
2         1           2 (2)             0
3         1           2 (2)             0
4         1           2 (2)             0
5         1           2 (2)             0
6         1           1 (1)             0
7         0           0 (0)             0
8         0           0 (0)             0
9         0           0 (0)             0
```



### lotus-bench 需要的环境变量
和worker一样：
```
export WORKER_PATH="/var/tmp/seal"
export LOTUS_WORKER_PATH="/var/tmp/seal"
export TMPDIR="/var/tmp/seal_tmp"

# for p1
export FIL_PROOFS_USE_MULTICORE_SDR=1

# for check
# echo $WORKER_PATH $TMPDIR $FIL_PROOFS_USE_MULTICORE_SDR

# 最大化内存
export FIL_PROOFS_MAXIMIZE_CACHING=1

#
export NVIDIA_VISIBLE_DEVICES=all
```
TMPDIR 指定的目录若不存在，bench seal的时候， 报找不到文件的错误
WORKER_PATH 制定的目录必须有超过600G的空间， 因为P1展开时，需要把这600G的文件放在这个目录， 这个目录如果小于600G， bench在跑了2个小时左右时间后， 会报空间不足错误而退出


### lotus-bench  启动命令
编译bench
RUSTFLAGS="-C target-cpu=native -g" FFI_BUILD_FROM_SOURCE=1  make lotus-bench
注意因为在amd上运行， 编译时必须有RUSTFLAGS="-C target-cpu=native -g" FFI_BUILD_FROM_SOURCE=1 


RUST_LOG=trace 在rust出错时， 可以看到trace

RUST_LOG=trace  nohup ./lotus-bench sealing --sector-size 32GiB --no-gpu true  --storage-dir=/var/tmp/bench/ > bench.log 2>&1 &

### lotus-bench 封装过程
P1 阶段的开始log：
```
2021-04-17T17:15:01.215 INFO filecoin_proofs::api > generate_piece_commitment:finish
2021-04-17T17:15:01.215 INFO filecoin_proofs::api > generate_piece_commitment:finish
2021-04-17T17:15:08.550 INFO filcrypto::proofs::api > generate_data_commitment: start
2021-04-17T17:15:08.550 INFO filecoin_proofs::api::seal > compute_comm_d:start
2021-04-17T17:15:08.551 INFO filecoin_proofs::pieces > verifying 8192 pieces
2021-04-17T17:15:08.553 INFO filecoin_proofs::api::seal > compute_comm_d:finish
2021-04-17T17:15:08.553 INFO filcrypto::proofs::api > generate_data_commitment: finish
2021-04-17T17:15:08.554+0800	INFO	lotus-bench	lotus-bench/main.go:562	[0] Running replication(1)...
2021-04-17T17:15:08.555 INFO filcrypto::proofs::api > seal_pre_commit_phase1: start
2021-04-17T17:15:08.556 INFO filecoin_proofs::api::seal > seal_pre_commit_phase1:start: SectorId(0)
2021-04-17T17:17:54.860 INFO filecoin_proofs::api::seal > building merkle tree for the original data
2021-04-17T17:17:54.861 TRACE filecoin_proofs::api::seal > seal phase 1: sector_size 34359738368, base tree size 2147483647, base tree leafs 1073741824
2021-04-17T17:17:54.863 TRACE storage_proofs_core::merkle::builders > create_merkle_tree called with size 1073741824
2021-04-17T17:17:54.863 TRACE storage_proofs_core::merkle::builders > is_merkle_tree_size_valid(1073741824, arity 2) = true


2021-04-17T17:22:16.240 INFO filecoin_proofs::api::seal > verifying pieces
2021-04-17T17:22:18.193 INFO filecoin_proofs::pieces > verifying 1 pieces
2021-04-17T17:22:18.211 INFO storage_proofs_porep::stacked::vanilla::proof > replicate_phase1
2021-04-17T17:22:18.211 INFO storage_proofs_porep::stacked::vanilla::graph > using parent_cache[2048 / 1073741824]
2021-04-17T17:22:18.212 INFO storage_proofs_porep::stacked::vanilla::cache > parent cache: opening /var/tmp/filecoin-parents/v28-sdr-parent-21981246c370f9d76c7a77ab273d94bde0ceb4e938292334960bce05585dc117.cache, verify enabled: false
2021-04-17T17:22:18.213 INFO storage_proofs_porep::stacked::vanilla::proof > multi core replication
2021-04-17T17:22:18.214 INFO storage_proofs_porep::stacked::vanilla::create_label::multi > create labels
2021-04-17T17:22:18.237 DEBUG storage_proofs_porep::stacked::vanilla::cores > Cores: 8, Shared Caches: 2, cores per cache (group_size): 4
2021-04-17T17:22:18.237 DEBUG storage_proofs_porep::stacked::vanilla::cores > checked out core group 0
2021-04-17T17:22:18.237 DEBUG storage_proofs_porep::stacked::vanilla::create_label::multi > binding core in main thread
2021-04-17T17:22:18.237 DEBUG storage_proofs_porep::stacked::vanilla::cores > allowed cpuset: 0,8
2021-04-17T17:22:18.237 DEBUG storage_proofs_porep::stacked::vanilla::cores > binding to 0
2021-04-17T17:22:18.237 INFO storage_proofs_porep::stacked::vanilla::memory_handling > initializing cache
2021-04-17T17:22:18.237 WARN storage_proofs_porep::stacked::vanilla::memory_handling > failed to lock map Os { code: 11, kind: WouldBlock, message: "Resource temporarily unavailable" }, falling back
2021-04-17T17:22:18.239 WARN storage_proofs_porep::stacked::vanilla::memory_handling > failed to lock map Os { code: 11, kind: WouldBlock, message: "Resource temporarily unavailable" }, falling back
2021-04-17T17:22:18.239 INFO storage_proofs_porep::stacked::vanilla::create_label::multi > Layer 1
2021-04-17T17:22:18.240 INFO storage_proofs_porep::stacked::vanilla::create_label::multi > Creating labels for layer 1
2021-04-17T17:22:18.240 DEBUG storage_proofs_porep::stacked::vanilla::create_label::multi > PRODUCER NOT READY! 1
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::create_label::multi > binding core in producer thread 2
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::cores > allowed cpuset: 3,11
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::cores > binding to 3
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::create_label::multi > binding core in producer thread 1
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::create_label::multi > binding core in producer thread 0
2021-04-17T17:22:18.241 INFO storage_proofs_porep::stacked::vanilla::create_label::multi > created label runner
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::cores > allowed cpuset: 1,9
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::cores > binding to 1
2021-04-17T17:22:18.241 INFO storage_proofs_porep::stacked::vanilla::create_label::multi > created label runner
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::cores > allowed cpuset: 2,10
2021-04-17T17:22:18.241 DEBUG storage_proofs_porep::stacked::vanilla::cores > binding to 2
2021-04-17T17:22:18.241 INFO storage_proofs_porep::stacked::vanilla::create_label::multi > created label runner
2021-04-17T17:22:19.065 DEBUG storage_proofs_porep::stacked::vanilla::create_label::multi > PRODUCER NOT READY! 1197697
2021-04-17T17:22:19.170 DEBUG storage_proofs_porep::stacked::vanilla::create_label::multi > PRODUCER NOT READY! 1356033
```

### .lotus-bench /home/fil/.lotus-bench/bench934131603/unsealed/s-t01000-0 空间不足

P1 产生的文件500多G
![-w729](media/16186546213623.jpg)

解决：
RUST_LOG=trace  nohup ./lotus-bench sealing --sector-size 32GiB --no-gpu=true  --storage-dir=/var/tmp/bench  --save-commit2-input=/var/tmp/c2 > bench.log 2>&1 &
--storage-dir=/var/tmp/bench/  制定的目录要大于600G
### 拷贝速度
nfs 从 nvme0 到nvme1  
![-w1060](media/16188023312068.jpg)
``



### service network restart 失败解决办法
![-w821](media/16186406160028.jpg)
解决办法： 
vi /etc/sysconfig/network-scripts/ifcfg-enp5s0
将ifcfg-xxx文件中的DEVICE一行注释掉。


### 32G sector p1 产生的中间文件
![-w503](media/16186626081687.jpg)



### p2 load average 达到16.0
![-w1773](media/16186660182649.jpg)
