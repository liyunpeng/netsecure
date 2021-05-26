### miner/config.toml修改
...
[API]
  ListenAddress = "/ip4/192.168.0.5/tcp/2345/http"
    产生MINER_API_INFO 里的地址， miner和worker之间也有api通讯

[Libp2p]
  ListenAddresses = ["/ip4/0.0.0.0/tcp/24001"] # choose a fixed port
  AnnounceAddresses = ["/ip4/<YOUR_PUBLIC_IP_ADDRESS>/tcp/24001"] # important!
  外网要用
...

[Libp2p]
  ListenAddresses = ["/ip4/0.0.0.0/tcp/24001"] # choose a fixed port
  AnnounceAddresses = ["/ip4/192.168.0.5/tcp/24001"] # important!

### miner attach sealer
[fil@miner ~]$ ./lotus-miner storage attach --init --seal  /sealer

命令产生这些文件：
![-w568](media/16188993610457.jpg)


存放永久文件的， 相当于备份， 这个存储可以是慢速机械硬盘：
```
[fil@miner ~]$ ./lotus-miner storage attach --init --store  /storage
```
命令及生成文件：
![-w664](media/16188998483922.jpg)


对应：  
use: storage
![-w684](media/16183012822556.jpg)




### 生成worker用的token
 ./lotus-miner auth api-info --perm admin
 
 
woker 上要导出的：
export MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.9VqfYQ830pI0W0oPFWIwvlfb93-5y0VWqTAYWWQdOjg:/ip4/192.168.0.5/tcp/2345/http
export TMPDIR=/home/fil/tmp-dir
export WORKER_PATH="/sealer"
export FIL_PROOFS_PARAMETER_CACHE=/var/tmp/filecoin-proof-parameters
export FIL_PROOFS_PARENT_CACHE=/var/tmp/filecoin-parents
export FIL_PROOFS_USE_MULTICORE_SDR=1



### lotus 启动
nohup ./lotus-worker run --listen="192.168.0.3:3456" --addpiece=true --precommit1=true --unseal=true --precommit2=true --commit=true > worker.log 2>&1 & 


### 没有启动worker1, 就停留在packing 
worker2 是做addpiece， p1的
![-w642](media/16189037838207.jpg)
addpiece 做finailize的

worker启动后， 会自动做这些
![-w642](media/16189038411087.jpg)


一下午，就都好了
![-w604](media/16189170814359.jpg)




### worker连不上miner 报错：
Connecting to miner API... (could not get API info: could not get api endpoint: API not running (no endpoint))
Log表示没有找到miner 的api， 

原因是.bashrc 没有export， 把
MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.4XcVTW7gJF0C2YVpPK-4jFuazoYBjnv7uKqUvQuBy7g:/ip4/192.168.0.5/tcp/2345/http
改为
export MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.4XcVTW7gJF0C2YVpPK-4jFuazoYBjnv7uKqUvQuBy7g:/ip4/192.168.0.5/tcp/2345/http
就对了
不

### p1 需要的证明参数文件很少， c2需要的证明参数文件很多
p1 需要的证明参数文件很少， 所以验证时间短些：
![-w1792](media/16192303324261.jpg)



c2需要的证明参数文件很少， 所以验证时间长些
![-w1792](media/16192302447539.jpg)
