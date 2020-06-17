
```
[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner -h
NAME:
   lotus-storage-miner - Filecoin decentralized storage network storage miner

USAGE:
   lotus-storage-miner [global options] command [command options] [arguments...]

VERSION:
   0.4.0+debug+git.82923049b

COMMANDS:
   deals      interact with your deals
   info       Print storage miner info
   init       Initialize a lotus storage miner repo
   rewards
   run        Start a lotus storage miner process
   stop       Stop a running lotus storage miner
   sectors    interact with sector store
   storage    manage sector storage
   set-price  Set price that miner will accept storage deals at (FIL / GiB / Epoch)
   workers    interact with workers
   proving
   fconfig    Force Pool Configuration
   db         access to local db derectly
   help, h    Shows a list of commands or help for one command
   basic:
     version  Print version
   developer:
     auth          Manage RPC permissions
     log           Manage logging
     wait-api      Wait for lotus api to come online
     fetch-params  Fetch proving parameters
   network:
     net  Manage P2P Network

GLOBAL OPTIONS:
   --storagerepo value                    (default: "~/.lotusstorage") [$LOTUS_STORAGE_PATH]
   --outsourcegpurepo value               (default: "~/.lotusoutsourcegpu") [$LOTUS_OUTSOURCE_GPU_PATH]
   --outsourcesealcommitphase2repo value  (default: "~/.lotusoutsourcesealcommitphase2") [$LOTUS_OUTSOURCE_SEAL_COMMIT_PHASE2_PATH]
   --help, -h                             show help (default: false)
   --version, -v                          print the version (default: false)
```

[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner info
Mode: poster
Miner: t02481
Sector Size: 512 MiB
Byte Power:   512 MiB / 135 TiB (0.0003%) .  算力 。   硬盘
Actual Power: 512 Mi / 101 Ti (0.0004%)     算力太小，  没有出块
	Committed: 512 MiB
	Proving: 512 MiB
Expected block win rate: 0.0691/day (every 347h13m20s)    表示1天只能出0.06个块， 

Miner Balance: 0.00009932400698959
	PreCommit:   0
	Locked:      0.000096344821570454
	Available:   0.000002979185419136
Worker Balance: 49.999900675992993622   
Market (Escrow):  0
Market (Locked):  0

Miner Balance: 0.00009932400698959  
算力包括硬盘指标， 和带宽指标， 
1个单位的硬盘指标 是 135TB
1个贷款指标是  101 Ti

自己的算力是自己拥有的和这个指标的比值。 

Miner Balance: 0.00009932400698959  挖矿的手续费用
	PreCommit:   0
	Locked:      0.000096344821570454   要抵押的费用
	Available:   0.000002979185419136    
	
Worker Balance: 49.999900675992993622     剩余的钱数

