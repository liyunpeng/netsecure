
#### 帮助信息
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

